{{- define "library-chart.azKeyVault.createInitContainer" }}
- name: azure-keyvault-retriever
  image: {{ .Values.azKeyVault.image.path }}:{{ .Values.azKeyVault.image.tag }}
  env:  
    - name: AZURE_CLIENT_ID
      valueFrom:
        secretKeyRef:
          name: {{ .Values.azKeyVault.loginSecretName }}
          key: azureClientId
    - name: AZURE_CLIENT_SECRET
      valueFrom:
        secretKeyRef:
          name: {{ .Values.azKeyVault.loginSecretName }}
          key: azureClientSecret
    - name: AZURE_TENANT_ID
      valueFrom:
        secretKeyRef:
          name: {{ .Values.azKeyVault.loginSecretName }}
          key: azureTenantId
    - name: KEY_VAULT_NAMES
      value: "{{ .Values.azKeyVault.vaultKeys | join "," }}"
    - name: SECRET_FILE_DIR
      value: "{{ .Values.azKeyVault.secretFileDir }}"
  volumeMounts:
    {{- include "library-chart.azKeyVault.createVolumeMount" . | nindent 3 }}  
{{- end }}

{{- define "library-chart.azKeyVault.createVolumeMount" }}
- name: secrets-volume
  mountPath: {{ .Values.azKeyVault.secretFileDir}}
{{- end }}


{{- define "library-chart.azKeyVault.createVolume" }}
- name: secrets-volume
  emptyDir: {}
{{- end }}