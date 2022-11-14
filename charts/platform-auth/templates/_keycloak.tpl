{{- define "platform-auth.app.keycloak.template" -}}
{{- with .Values.nodeSelector }}
nodeSelector:
  {{ toYaml . | indent 2}}
{{- end }}
{{- with .Values.tolerations }}
tolerations:
{{ range .Values.tolerations }}
  - {{ .  | quote}}
{{- end }}
{{- end }}
fullnameOverride: {{ include "platform-auth.keycloak.name" $ }}
extraEnv: |
  {{- if or .Values.components.keycloak.admin.username .Values.components.keycloak.admin.usernameSecretRef }}
  - name: KEYCLOAK_ADMIN
   {{- if .Values.components.keycloak.admin.usernameSecretRef }}
    valueFrom:
      secretKeyRef: {{- toYaml .Values.components.keycloak.admin.usernameSecretRef | nindent 8 }}    
  {{- else }}
    value: {{ .Values.components.keycloak.admin.username | quote }}
  {{- end }}
  {{- end }}
  {{- if or .Values.components.keycloak.admin.password .Values.components.keycloak.admin.passwordSecretRef }}
  - name: KEYCLOAK_ADMIN_PASSWORD
   {{- if .Values.components.keycloak.admin.passwordSecretRef }}
    valueFrom:
      secretKeyRef: {{- toYaml .Values.components.keycloak.admin.passwordSecretRef | nindent 8}}
  {{- else }}
    value: {{ .Values.components.keycloak.admin.password | quote }}
  {{- end }}
  {{- end }}
  - name: KC_DB_PASSWORD
    valueFrom:
      secretKeyRef:
        key: {{ .Values.components.keycloak.storage.auth.secretKeys.userPasswordKey }}
        name: {{ .Values.components.keycloak.storage.auth.existingSecret }}
  - name: JAVA_OPTS_APPEND
    value: >-
      -XX:+UseContainerSupport
      -XX:MaxRAMPercentage=50.0
      -Djava.awt.headless=true
      -Djgroups.dns.query={{ include "platform-auth.postgresql.name" $ }}-hl
command:
  - "/opt/keycloak/bin/kc.sh"
  - "--verbose"
  - "start"
  - "--auto-build"
  - "--http-enabled=true"
  - "--http-port=8080"
  - "--hostname-strict=false"
  - "--hostname-strict-https=false"
  - "--spi-events-listener-jboss-logging-success-level=info"
  - "--spi-events-listener-jboss-logging-error-level=warn"
dbchecker:
  enabled: true
database:
  vendor: postgres
  hostname: {{ include "platform-auth.postgresql.name" $ }}
  port: 5432
  database: {{ .Values.components.keycloak.storage.auth.database }}
  username: {{ .Values.components.keycloak.storage.auth.username }}
{{- end -}}