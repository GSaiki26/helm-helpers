{{- define "gsaiki-helpers.deployment" }}
{{ $root := . }}
apiVersion: apps/v1
kind: Deployment
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
  replicas: {{ .replicas | default 1 }}

  selector:
    matchLabels:
      app.kubernetes.io/name: {{ .name | default $root.name }}{{ .nameSuffix }}
      {{- with .instance }}
      app.kubernetes.io/instance: {{ . }}
      {{- end }}
      {{- with .component }}
      app.kubernetes.io/component: {{ . }}
      {{- end }}
      {{- with .labels }}
      {{- toYaml . | nindent 6 }}
      {{- end }}
  template:
    metadata:
      labels:
        app.kubernetes.io/name: {{ .name | default $root.name }}{{ .nameSuffix }}
        {{- with .instance }}
        app.kubernetes.io/instance: {{ . }}
        {{- end }}
        {{- with .component }}
        app.kubernetes.io/component: {{ . }}
        {{- end }}
        {{- with .labels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    spec:
      {{- $volumes := list }}
      {{- range .containers }}
      {{- $volumes = concat $volumes (dig "volumes" list .)}}
      {{- end }}

      {{- with $volumes }}
      volumes:
      {{- range . }}
      - name: {{ .name | default $root.name }}{{ .nameSuffix }}
        {{ .type }}:
          {{- if eq .type "persistentVolumeClaim" }}
          claimName: {{ .name | default $root.name }}{{ .nameSuffix }}
          {{- else if eq .type "configMap" }}
          name: {{ .name | default $root.name }}{{ .nameSuffix }}
          {{- if hasKey . "items" }}
          {{- toYaml .items | nindent 8 }}
          {{- end }}
          {{- else if eq .type "secret" }}
          secretName: {{ .name | default $root.name }}{{ .nameSuffix }}
          {{- end }}
      {{- end }}
      {{- end }}

      containers:
      {{- range .containers }}
      - name: {{ .name | default $root.name }}{{ .nameSuffix }}
        image: "{{ .image.name }}:{{ .image.tag }}"
        imagePullPolicy: {{ .image.pullPolicy | default "IfNotPresent" }}
        {{- with .command }}
        command:
          {{- range . }}
        - {{ . | quote }}
          {{- end }}
        {{- end }}
        resources:
          requests:
            cpu: {{ dig "cpu" "requests" "50m" . }}
            memory: {{ dig "memory" "requests" "128Mi" . }}
          limits:
            cpu: {{ dig "cpu" "limits" "50m" . }}
            memory: {{ dig "memory" "limits" "128Mi" . }}

        {{- with .ports }}
        ports:
        {{- range . }}
        - containerPort: {{ .port }}
          {{- with .name }}
          name: {{ . }}
          {{- end }}
          protocol: {{ .protocol | default "TCP" }}
        {{- end }}
        {{- end }}

        {{- with .volumes }}
        volumeMounts:
        {{- range . }}
        - name: {{ .name | default $root.name }}{{ .nameSuffix }}
          mountPath: {{ .mountPath }}
          {{- with .subPath }}
          subPath: {{ . }}
          {{- end }}
          readOnly: {{ .readOnly | default false }}
        {{- end }}
        {{- end }}

        {{- $envWithValue := list }}
        {{- $envWithRef := list }}
        {{- range .env }}
          {{- if hasKey . "value" }}
            {{- $envWithValue = append $envWithValue . }}
          {{- else }}
            {{- $envWithRef = append $envWithRef . }}
          {{- end }}
        {{- end }}

        {{- with $envWithValue }}
        env:
        {{- range .  }}
        - name: {{ .name | default $root.name }}{{ .nameSuffix }}
          value: {{ .value }}
        {{- end }}
        {{- end }}

        {{- with $envWithRef }}
        envFrom:
        {{- range .  }}
        - {{ .type }}:
            name: {{ .name | default $root.name }}{{ .nameSuffix }}
        {{- end }}
        {{- end }}

      {{- end }}
{{- end }}
