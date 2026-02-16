livedebugging {
  enabled = true
}

discovery.kubernetes "kubernetes_pods" {
  role = "pod"
}

discovery.relabel "kubernetes_pods" {
  targets = discovery.kubernetes.kubernetes_pods.targets

  rule {
    source_labels = ["__meta_kubernetes_pod_controller_name"]
    regex         = "([0-9a-z-.]+?)(-[0-9a-f]{8,10})?"
    target_label  = "__tmp_controller_name"
  }

  rule {
    source_labels = ["__meta_kubernetes_pod_label_app_kubernetes_io_name", "__meta_kubernetes_pod_label_app", "__tmp_controller_name", "__meta_kubernetes_pod_name"]
    regex         = "^;*([^;]+)(;.*)?$"
    target_label  = "app"
  }

  rule {
    source_labels = ["__meta_kubernetes_pod_label_app_kubernetes_io_instance", "__meta_kubernetes_pod_label_instance"]
    regex         = "^;*([^;]+)(;.*)?$"
    target_label  = "instance"
  }

  rule {
    source_labels = ["__meta_kubernetes_pod_label_app_kubernetes_io_component", "__meta_kubernetes_pod_label_component"]
    regex         = "^;*([^;]+)(;.*)?$"
    target_label  = "component"
  }

  rule {
    source_labels = ["__meta_kubernetes_pod_node_name"]
    target_label  = "node_name"
  }

  rule {
    source_labels = ["__meta_kubernetes_namespace"]
    target_label  = "namespace"
  }

  rule {
    source_labels = ["namespace", "app"]
    separator     = "/"
    target_label  = "job"
  }

  rule {
    source_labels = ["__meta_kubernetes_pod_name"]
    target_label  = "pod"
  }

  rule {
    source_labels = ["__meta_kubernetes_pod_container_name"]
    target_label  = "container"
  }

  rule {
    source_labels = ["__meta_kubernetes_pod_uid", "__meta_kubernetes_pod_container_name"]
    separator     = "/"
    target_label  = "__path__"
    replacement   = "/var/log/pods/*$1/*.log"
  }

  rule {
    source_labels = ["__meta_kubernetes_pod_annotationpresent_kubernetes_io_config_hash", "__meta_kubernetes_pod_annotation_kubernetes_io_config_hash", "__meta_kubernetes_pod_container_name"]
    separator     = "/"
    regex         = "true/(.*)"
    target_label  = "__path__"
    replacement   = "/var/log/pods/*$1/*.log"
  }
}

local.file_match "kubernetes_pods" {
  path_targets = discovery.relabel.kubernetes_pods.output
}

loki.process "kubernetes_pods" {
  forward_to = [loki.write.default.receiver]

  stage.cri {}

  stage.decolorize {}
}

loki.source.file "kubernetes_pods" {
  targets               = local.file_match.kubernetes_pods.targets
  forward_to            = [loki.process.kubernetes_pods.receiver]
  legacy_positions_file = "/run/promtail/positions.yaml"
}

loki.write "default" {
  endpoint {
    url = "http://loki-gateway/loki/api/v1/push"
  }
  external_labels = {}
}

loki.source.kubernetes_events "cluster_events" {
  job_name   = "integrations/kubernetes/eventhandler"
  log_format = "logfmt"
  forward_to = [
    loki.process.cluster_events.receiver,
  ]
}

loki.process "cluster_events" {
  forward_to = [loki.write.default.receiver]

  stage.regex {
    expression = ".*name=(?P<name>[^ ]+).*kind=(?P<kind>[^ ]+).*objectAPIversion=(?P<apiVersion>[^ ]+).*type=(?P<type>[^ ]+).*"
  }

  stage.labels {
    values = {
      kubernetes_cluster_events = "job",
      name                      = "name",
      kind                      = "kind",
      apiVersion                = "apiVersion",
      type                      = "type",
    }
  }

  stage.match {
    selector = "{kind=\"IPAddress\"}"
    action   = "drop"
  }
}

otelcol.receiver.otlp "default" {
  grpc {
    endpoint = "0.0.0.0:4317"
  }

  http {
    endpoint = "0.0.0.0:4318"
  }

  output {
    metrics = [otelcol.processor.batch.default.input]
    logs    = [otelcol.processor.batch.default.input]
    # traces  = [otelcol.connector.servicegraph.default.input, otelcol.processor.tail_sampling.default.input]
  }
}

otelcol.connector.servicegraph "default" {
  dimensions = ["http.method"]

  debug_metrics {}

  output {
    metrics = [otelcol.exporter.prometheus.default.input]
  }
}

otelcol.processor.batch "default" {
  output {
    metrics = [otelcol.exporter.prometheus.default.input]
    logs    = [otelcol.exporter.loki.default.input]
    traces  = [otelcol.exporter.otlp.default.input]
  }
}

otelcol.processor.tail_sampling "default" {
  decision_wait = "10s"

  policy {
    name = "keep-errors"
    type = "status_code"
    status_code {
      status_codes = ["ERROR"]
    }
  }

  policy {
    name = "sample-half"
    type = "probabilistic"
    probabilistic {
      sampling_percentage = 50
    }
  }

  output {
    traces = [otelcol.exporter.otlp.default.input]
  }
}

otelcol.exporter.otlp "default" {
  client {
    endpoint = "tempo.monitoring:4317"

    tls {
      insecure = true
    }
  }
}

otelcol.exporter.prometheus "default" {
  forward_to = [prometheus.remote_write.default.receiver]
}

otelcol.exporter.loki "default" {
  forward_to = [loki.write.default.receiver]
}

prometheus.remote_write "default" {
  endpoint {
    url = "http://vmsingle-metrics.monitoring:8429/api/v1/write"
  }
}
