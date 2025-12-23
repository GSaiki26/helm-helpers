{{- define "gsaiki-helpers.externalSecret" }}
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: {{ .name }}{{ .nameSuffix }}
  labels:
    app.kubernetes.io/name: {{ .name }}
    {{- with .instance }}
    app.kubernetes.io/instance: {{ . }}
    {{- end }}
    {{- with .component }}
    app.kubernetes.io/component: {{ . }}
    {{- end }}
    {{- with .labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- with .annotations }}
  annotations:
  {{- toYaml . | nindent 4 }}
  {{- end }}

spec:
  refreshInterval: {{ .refreshInterval | default "5m" }}
  secretStoreRef:
    name: {{ .secretStore.name }}
    kind: {{ .secretStore.kind | default "ClusterSecretStore" }}
  target:
    name: {{ .name }}{{ .nameSuffix }}
  {{- range $key, $value := .references }}
  {{ $key }}:
    {{- toYaml $value | nindent 4 }}
  {{- end }}
{{- end -}}
