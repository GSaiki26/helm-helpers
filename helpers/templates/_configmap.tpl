{{- define "gsaiki-helpers.configMap" }}
{{- $root := . }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .name | default $root.name }}{{ .nameSuffix }}
  labels:
    app.kubernetes.io/name: {{ .name | default $root.name }}{{ .nameSuffix }}
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
data:
  {{- toYaml .data | nindent 2 }}
{{- end }}