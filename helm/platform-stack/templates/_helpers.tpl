{{/* Helper templates for the platform stack chart. */}}
{{- define "platform-stack.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "platform-stack.labels" -}}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: acme-platform
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version }}
environment: {{ .Values.environment | quote }}
{{- end -}}
