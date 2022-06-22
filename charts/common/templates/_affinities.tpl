{{/* Generate common affinity */}}

{{- define "common.affinities.nodes.soft" }}
preferredDuringSchedulingIgnoredDuringExecution:
  - preference:
      matchExpressions:
        - key: {{ .key }}
          operator: In
          values:
            {{- range .values }}
            - {{ . | quote }}
            {{- end }}
    weight: 1
{{- end -}}

{{- define "common.affinities.nodes.hard" }}
requiredDuringSchedulingIgnoredDuringExecution:
  nodeSelectorTerms:
    - matchExpressions:
        - key: {{ .key }}
          operator: In
          values:
            {{- range .values }}
            - {{ . | quote }}
            {{- end }}
{{- end -}}

{{/*
Return a nodeAffinity definition
{{ include "common.affinities.nodes" (dict "type" "soft" "key" "FOO" "values" (list "BAR" "BAZ")) -}}
*/}}
{{- define "common.affinities.nodes" -}}
  {{- if eq .type "soft" }}
    {{- include "common.affinities.nodes.soft" . -}}
  {{- else if eq .type "hard" }}
    {{- include "common.affinities.nodes.hard" . -}}
  {{- end -}}
{{- end -}}

{{- define "common.affinities.pods.soft" }}
affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 2
      podAffinityTerm:
        labelSelector:
          matchExpressions:
          - key: {{ .key }}
            operator: In
            values:
            {{- range .values }}
            - {{ . | quote }}
            {{- end }}
        topologyKey: topology.kubernetes.io/zone
    - weight: 1
      podAffinityTerm:
        labelSelector:
          matchExpressions:
          - key: {{ .key }}
            operator: In
            values:
            {{- range .values }}
            - {{ . | quote }}
            {{- end }}
        topologyKey: kubernetes.io/hostname
{{- end }}

{{- define "common.affinities.pods.hard" }}
affinity:
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
    - weight: 2
      podAffinityTerm:
        labelSelector:
          matchExpressions:
          - key: {{ .key }}
            operator: In
            values:
            {{- range .values }}
            - {{ . | quote }}
            {{- end }}
        topologyKey: topology.kubernetes.io/zone
    - weight: 1
      podAffinityTerm:
        labelSelector:
          matchExpressions:
          - key: {{ .key }}
            operator: In
            values:
            {{- range .values }}
            - {{ . | quote }}
            {{- end }}
        topologyKey: kubernetes.io/hostname
{{- end }}

{{/*
Return a podAffinity/podAntiAffinity definition
{{ include "common.affinities.pods" (dict "type" "soft" "key" "FOO" "values" (list "BAR" "BAZ")) -}}
*/}}
{{- define "common.affinities.pods" -}}
  {{- if eq .type "soft" }}
    {{- include "common.affinities.pods.soft" . -}}
  {{- else if eq .type "hard" }}
    {{- include "common.affinities.pods.hard" . -}}
  {{- end -}}
{{- end -}}