{{- define "gsaiki-helpers.pvc" }}
apiVersion: v1
kind: PersistentVolumeClaim
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
  {{- with .storageClass }}
  {{- with .name }}
  storageClassName: "{{- . }}"
  {{- end }}
  {{- end }}
  volumeMode: {{ .volumeMode | default "Filesystem" }}
  accessModes:
  {{- toYaml (.accessModes | default (list "ReadWriteOnce")) | nindent 4 }}

  resources:
    requests:
      storage: {{ .storage.requests }}
{{- end -}}
