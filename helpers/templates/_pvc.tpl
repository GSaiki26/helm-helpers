{{- define "gsaiki-helpers.pvc" }}
{{- $root := . }}
apiVersion: v1
kind: PersistentVolumeClaim
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
spec:
  {{- $sc := dig "storageClass" "name" "" . }}
  {{- if $sc }}
  storageClassName: {{- $sc }}
  {{- end }}
  volumeMode: {{ .volumeMode | default "Filesystem" }}
  accessModes:
  {{- toYaml (.accessModes | default (list "ReadWriteOnce")) | nindent 4 }}

  resources:
    requests:
      storage: {{ .storage.requests }}
{{- end -}}
