{{- define "gsaiki-helpers.httpRoute" }}
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: {{ .name }}{{ .nameSuffix | default "-route" }}
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
  parentRefs:
  {{- toYaml .gateways | nindent 4 }}
  hostnames:
  {{- toYaml .hostnames | nindent 4 }}
  rules:
  {{- range .rules }}
  {{- $rule := . }}
    - matches:
      {{- range .matches }}
      - {{ .matchType }}:
          type: {{ .type }}
          value: {{ .value }}
      {{- end }}

      backendRefs:
      {{- range .backendRefs }}
      - name: {{ .name }}
        port: {{ .port }}
      {{- end }}

  {{- end }}
{{- end }}
