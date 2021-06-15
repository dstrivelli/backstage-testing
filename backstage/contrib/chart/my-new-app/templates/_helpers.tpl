{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "my-new-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "my-new-app.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "my-new-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "my-new-app.labels" -}}
helm.sh/chart: {{ include "my-new-app.chart" . }}
{{ include "my-new-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
backstage.io/kubernetes-id: {{ .Values.backstageID }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
backstage.io/kubernetes-id: {{ .Values.backstageID }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "my-new-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "my-new-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
backstage.io/kubernetes-id: {{ .Values.backstageID }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "my-new-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "my-new-app.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
