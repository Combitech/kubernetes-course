{{/*
Expand the name of the chart.
*/}}
{{- define "demonstrator.name" -}}
{{ printf "%s-%s" .Release.Name "demo" }}
{{- end }}
