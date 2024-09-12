{{/*
Expand the name of the chart.
*/}}
{{- define "platform-o11y.name" -}}
  {{- default .Chart.Name .Values.nameOverride }}
{{- end }}

{{- define "platform-o11y.format.name" -}}
  {{- $ := last . -}}
  {{- prepend . $.Values.prefix | initial | include "skyfjell.common.format.name" -}}
{{- end }}

{{- define "platform-o11y.postgresql.userPasswordKey" -}}
{{- if .Values.components.keycloak.storage.valuesOverride.global.postgresql.auth.secretKeys.userPasswordKey }}
  {{- printf "%s" (tpl .Values.components.keycloak.storage.valuesOverride.global.postgresql.auth.secretKeys.userPasswordKey $) -}}
{{- else if .Values.components.keycloak.storage.valuesOverride.auth.secretKeys.userPasswordKey -}}
  {{- printf "%s" (tpl .Values.components.keycloak.storage.valuesOverride.auth.secretKeys.userPasswordKey $) -}}
{{- else -}}
  {{- print "postgres" -}}
{{- end -}}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "platform-o11y.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "platform-o11y.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "platform-o11y.labels" -}}
helm.sh/chart: {{ include "platform-o11y.chart" . }}
{{ include "platform-o11y.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "platform-o11y.selectorLabels" -}}
app.kubernetes.io/name: {{ include "platform-o11y.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "platform-o11y.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "platform-o11y.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
