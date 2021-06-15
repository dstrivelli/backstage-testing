backend:
  lighthouseHostname: {{ include "lighthouse.serviceName" . | quote }}
  listen:
      port: {{ .Values.appConfig.backend.listen.port | default 7000 }}
  database:
    client: {{ .Values.appConfig.backend.database.client | quote }}
    connection:
      host: {{ include "backend.postgresql.host" . | quote }}
      port: {{ include "backend.postgresql.port" . | quote }}
      user: {{ include "backend.postgresql.user" . | quote }}
      database: {{ .Values.appConfig.backend.database.connection.database | quote }}
      ssl:
        rejectUnauthorized: {{ .Values.appConfig.backend.database.connection.ssl.rejectUnauthorized | quote }}
        ca: {{ include "backstage.backend.postgresCaFilename" . | quote }}

catalog:
{{- if .Values.backend.demoData }}
  rules:
    - allow: [Component, API, Group, User, Template, Location]
  locations:
    # Backstage example templates
    - type: url
      target: https://github.com/dstrivelli/backstage-testing/blob/main/java-spring-template/template.yaml
      rules:
        - allow: [Template]
    - type: url
      target: https://github.com/backstage/backstage/blob/master/plugins/scaffolder-backend/sample-templates/react-ssr-template/template.yaml
      rules:
        - allow: [Template]
    - type: url
      target: https://github.com/backstage/backstage/blob/master/plugins/scaffolder-backend/sample-templates/springboot-grpc-template/template.yaml
      rules:
        - allow: [Template]
    - type: url
      target: https://github.com/spotify/cookiecutter-golang/blob/master/template.yaml
      rules:
        - allow: [Template]
    - type: url
      target: https://github.com/backstage/backstage/blob/master/plugins/scaffolder-backend/sample-templates/docs-template/template.yaml
      rules:
        - allow: [Template]
{{- else }}
  locations: []
{{- end }}

kubernetes:
  serviceLocatorMethod: 'multiTenant'
  clusterLocatorMethods:
    - 'config'
  clusters:
    - url: https://api.alt8.bip.va.gov
      name: alt8
      authProvider: 'serviceAccount'
      serviceAccountToken: eyJhbGciOiJSUzI1NiIsImtpZCI6ImRmYTljZDgwNWVmZmIyZGVlMGMwMmYzMzM5MTg3ZTQ0ZDhjYWQyNTMifQ.eyJpc3MiOiJodHRwczovL2RleC5hbHQ4LmJpcC52YS5nb3YiLCJzdWIiOiJDajUxYVdROVpITjBjbWwyWld4c2FTeGpiajExYzJWeWN5eGpiajFoWTJOdmRXNTBjeXhrWXoxa1pYWXNaR005WW1sd0xHUmpQWFpoTEdSalBXZHZkaElFYkdSaGNBIiwiYXVkIjoiYWx0OCIsImV4cCI6MTYxNjAwNzM1NCwiaWF0IjoxNjE1OTIwOTU0LCJhdF9oYXNoIjoidkdJd3VuclJaMjhRU3ZQU3lsdE5aZyIsImVtYWlsIjoiZGFuaWVsLnN0cml2ZWxsaUB2YS5nb3YiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiZ3JvdXBzIjpbImFkbWlucyIsImlwYXVzZXJzIiwiamVua2luc19hZG1pbnMiLCJuZXh1c19hZG1pbnMiLCJiaXAtcHJvamVjdC1hZG1pbnMiLCJiaXAtcGxhdGZvcm0tYWRtaW5zIiwiYmlwLW1ibXMtYWRtaW5zIiwiYmlwLWNsdXN0ZXItYWRtaW5zIiwic29uYXItYWRtaW5pc3RyYXRvcnMiLCJwbGF0Zm9ybS1qZW5raW5zLWFkbWlucyIsIm5hbWVzcGFjZSIsImZ0aS1nb3Ytb25seSJdLCJuYW1lIjoiRGFuaWVsIFN0cml2ZWxsaSJ9.JCHqLIFtWt9SuZlEI5jToWLrIH_qooJFzGNS72VgMtRCnf-W_Zwunu084uCbgcvUtsAB5ct1CDyOAWVwJ8QOe6Lkh7c5IEnCbkQNyN5duqN_Yk-ms5sBQjCpucL_3F1Xu_GVY51xX8ep7Mu39XG7IWjE2Xbh5SLe6msIgPKEa-6hz7LyF2_CWEBAsGEW9_P-ZdRNoqxW3R4n2NC9gJNjWzgS5RZxz3ylHM1m8-VSTs2OVrqsAzDK8yWrSakzpz2-Sb2ifhJmZoVgFNLAhgNqs1nQNglEJO4p5omYUr080gtHtYv9AbyXlp2IVmvydjzqretjh8b4PJ61qiIFWElQxw


auth:
  providers:
    github:
      development:
        appOrigin: 'https://backstage.alt8.bip.va.gov'
        secure: false
        clientId:
          $env: AUTH_GITHUB_CLIENT_ID
        clientSecret:
          $env: AUTH_GITHUB_CLIENT_SECRET
        enterpriseInstanceUrl:
          $env: AUTH_GITHUB_ENTERPRISE_INSTANCE_URL

scaffolder:
  github:
    token:
      $env: GITHUB_TOKEN
    visibility: public # or 'internal' or 'private'


sentry:
  organization: {{ .Values.appConfig.sentry.organization | quote }}

techdocs:
  builder: 'local' # Alternatives - 'external'
  generators:
    techdocs: 'local' # Alternatives - 'local'
  publisher:
    type: 'local' # Alternatives - 'googleGcs' or 'awsS3'. Read documentation for using alternatives.
