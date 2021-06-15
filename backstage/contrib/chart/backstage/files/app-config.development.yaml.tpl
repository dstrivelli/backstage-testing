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
    # Backstage example components
    - type: url
      target: https://github.com/backstage/backstage/blob/master/packages/catalog-model/examples/all-components.yaml

    # Backstage example APIs
    - type: url
      target: https://github.com/backstage/backstage/blob/master/packages/catalog-model/examples/all-apis.yaml

    # Backstage example templates
    - type: url
      target: https://github.com/backstage/backstage/blob/master/plugins/scaffolder-backend/sample-templates/react-ssr-template/template.yaml
      rules:
        - allow: [Template]
    - type: url
      target: https://github.com/backstage/backstage/blob/master/plugins/scaffolder-backend/sample-templates/springboot-grpc-template/template.yaml
      rules:
        - allow: [Template]
    - type: url
      target: https://github.com/dstrivelli/backstage-testing/blob/main/simple-application-with-docs/template.yaml
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
    - url: https://192.168.99.100:8443
      name: minikube
      authProvider: 'serviceAccount'
      serviceAccountToken: eyJhbGciOiJSUzI1NiIsImtpZCI6InpSOEctdjFEV04wT0lqUHctX19JVFR1OERCRG4yZ3NnN0Z1Q09UX1F3dkkifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJiYWNrc3RhZ2UiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlY3JldC5uYW1lIjoiZGVmYXVsdC10b2tlbi13NWRibCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiYjNiMDU5YzctODYxOS00OTUwLWIwNTgtMWE4ZTMxMDQxYjRhIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OmJhY2tzdGFnZTpkZWZhdWx0In0.FhIaVU523WKjdyp9iTZoikoCKuQ3CJvvGlvQOUyMZrm3qPp7T4jspQi4qyI6m3pfZ6Plk1doUYtm4GcGjyggPaA0y2F74DaU6pni-x6DgwVUPTrtimlyxV8gxOWTPZMLANfgfAHe563sLsLRTQViKgWZDy8H5WZfJQFNuRwtWzk4aO4it6x5EFXyVjT4BHrKR-zNN-jtaSVpf4LrCTiNDSkgHWPNUllJ9QTulXX5YRjclY9VqG5zvF-qpcZ8UbVGnGLhVRxx0liiKXqFc2Vo4-21fLB-ICeArb9uq0whO4HT1Y-rvBCzx9FNOh3D58f-KHoqAHOk5Qj9rXl5HQtbHA


auth:
  providers:
    github:
      development:
        appOrigin: 'https://backstage.local'
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
