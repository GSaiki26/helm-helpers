{{- define "gsaiki-helpers.configMap" }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .name }}{{ .nameSuffix | default "-cfg" }}
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
data:
  {{- toYaml .data | nindent 2 }}
{{- end }}