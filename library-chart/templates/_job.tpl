{{- define "library-chart.createJob" -}}
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ .Release.Name }}
  labels:
    {{- include "library-chart.labels" . | nindent 4 }}
spec:
  backoffLimit: {{ .Values.backoffLimit }}
  template:
    metadata:
      {{- with .Values.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      labels:
        {{- include "library-chart.labels" . | nindent 8 }}
        {{- with .Values.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    spec:
      {{- with .Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ include "library-chart.serviceAccountName" . }}
      securityContext:
        {{- toYaml .Values.podSecurityContext | nindent 8 }}
      initContainers:
      {{- if .Values.azKeyVault.enabled }}
        {{- include "library-chart.azKeyVault.createInitContainer" . | nindent 7 }}
      {{- end }}
      containers:
        - name: {{ .Chart.Name }}
          securityContext:
            {{- toYaml .Values.securityContext | nindent 12 }}
          image: "{{ .Values.image.registry }}/{{ .Values.image.path }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          {{- with .Values.command }}
          command :
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with .Values.env }}
          env :
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with .Values.ports }}
          ports:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- if .Values.livenessProbe }}
          livenessProbe:
            {{- toYaml .Values.livenessProbe | nindent 12 }}
          {{- end }}
          {{- if .Values.readinessProbe }}
          readinessProbe:
            {{- toYaml .Values.readinessProbe | nindent 12 }}
          {{- end }}
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
          volumeMounts:
          {{- with .Values.volumeMounts }}
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- if .Values.azKeyVault.enabled }}
            {{- include "library-chart.azKeyVault.createVolumeMount" . | nindent 12 }}          
          {{- end }}
      volumes:
      {{- with .Values.volumes }}
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- if .Values.azKeyVault.enabled }}
        {{- include "library-chart.azKeyVault.createVolume" . | nindent 7 }}   
      {{- end }}
      restartPolicy: {{ .Values.restartPolicy }}
      {{- with .Values.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
{{- end }}