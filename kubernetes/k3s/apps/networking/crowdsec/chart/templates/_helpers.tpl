{{/*
  Provide a default value for StoreLAPICscliCredentialsInSecret.
  If TLS is enabled return false (user/password auth is not compatible with TLS auth).
  Else if StoreLAPICscliCredentialsInSecret is not set in the values, and there's no persistency for the LAPI config, defaults to true
*/}}
{{ define "StoreLAPICscliCredentialsInSecret" }}
{{- if .Values.tls.enabled -}}
false
{{- else -}}
{{ dig "storeLAPICscliCredentialsInSecret" (not .Values.lapi.persistentVolume.config.enabled) .Values.lapi }}
{{- end -}}
{{- end -}}
