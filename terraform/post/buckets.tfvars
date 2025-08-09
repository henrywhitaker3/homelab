buckets = {
  dragonfly = {
    name      = "dragonfly"
    retention = 3
    acl       = "private"
    type      = "minio"
  }
  loki = {
    name      = "loki-chunks"
    acl       = "private"
    type      = "minio"
    retention = 60
  }
  mariadb = {
    name = "mariadb"
    acl  = "private"
    type = "minio"
  }
  orderly = {
    name      = "orderly"
    acl       = "private"
    type      = "minio"
    retention = 3
  }
  pyroscope = {
    name = "pyroscope"
    acl  = "private"
    type = "minio"
  }
  tempo = {
    name = "tempo"
    acl  = "private"
    type = "minio"
  }
  yourbuild = {
    name = "yourbuild"
    acl  = "private"
    type = "minio"
  }
  longhorn = {
    name = "longhorn"
    type = "r2"
  }
  crunchy = {
    name = "crunchy"
    type = "r2"
  }
  mariadb_r2 = {
    name = "mariadb"
    type = "r2"
  }
  books = {
    name = "books"
    type = "r2"
  }
  thesuses_state = {
    name = "thesuses-state"
    type = "r2"
  }
  longhorn_local = {
    name = "longhorn"
    type = "garage"
  }
  mariadb_local = {
    name = "mariadb"
    type = "garage"
  }
  crunchy_local = {
    name = "crunchy"
    type = "garage"
  }
  dragonfly_local = {
    name = "dragonfly"
    type = "garage"
  }
}

minio_tokens = {
  dragonfly = {
    name    = "dragonfly"
    buckets = ["dragonfly"]
    write   = true
  }
  loki = {
    name    = "loki"
    buckets = ["loki"]
    write   = true
  }
  mariadb = {
    name    = "mariadb"
    buckets = ["mariadb"]
    write   = true
  }
  orderly = {
    name    = "orderly"
    buckets = ["orderly"]
    write   = true
  }
  pyroscope = {
    name    = "pyroscope"
    buckets = ["pyroscope"]
    write   = true
  }
  tempo = {
    name    = "tempo"
    buckets = ["tempo"]
    write   = true
  }
  yourbuild = {
    name    = "yourbuild"
    buckets = ["yourbuild"]
    write   = true
  }
}

r2_tokens = {
  longhorn = {
    buckets = ["longhorn"]
    write   = true
  }
  crunchy = {
    buckets = ["crunchy"]
    write   = true
  }
  mariadb = {
    buckets = ["mariadb"]
    write   = true
  }
  books = {
    buckets = ["books"]
    write   = true
  }
  thesuses_state = {
    buckets = ["thesuses_state"]
    write   = true
  }
}

garage_tokens = {
  longhorn = {
    name    = "longhorn"
    buckets = ["longhorn_local"]
    write   = true
  }
  mariadb = {
    name    = "mariadb"
    buckets = ["mariadb_local"]
    write   = true
  }
  crunchy = {
    name    = "crunchy"
    buckets = ["crunchy_local"]
    write   = true
  }
  dragonfly = {
    name    = "dragonfly"
    buckets = ["dragonfly_local"]
    write   = true
  }
}
