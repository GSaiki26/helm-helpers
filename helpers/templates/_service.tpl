{{- define "gsaiki-helpers.service" }}
apiVersion: v1
kind: Service
metadata:
  name: {{ .name }}{{ .nameSuffix | default "-svc"}}
  labels:
    app.kubernetes.io/name: "{{ .name }}"
    {{- with .instance }}
    app.kubernetes.io/instance: "{{ . }}"
    {{- end }}
    {{- with .component }}
    app.kubernetes.io/component: "{{ . }}"
    {{- end }}
    {{- with .labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- with .annotations }}
  annotations:
  {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  selector:
    app.kubernetes.io/name: "{{ .name }}"
    {{- with .instance }}
    app.kubernetes.io/instance: "{{ . }}"
    {{- end }}
    {{- with .component }}
    app.kubernetes.io/component: "{{ . }}"
    {{- end }}
    {{- with .labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  type: {{ .type | default "ClusterIP" }}
  ports:
    {{- range .ports }}
    - port: {{ .port }}
      targetPort: {{ .targetPort | default .port }}
      {{- with .nodePort }}
      nodePort: "{{ . }}"
      {{- end }}
      {{- with .portName }}
      name: "{{ . }}"
      {{- end }}
      protocol: {{ .protocol | default "TCP" }}
    {{- end }}
{{- end -}}
