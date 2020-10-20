Rails.application.routes.draw do
  mount KeycloakOauth::Engine => "/keycloak_oauth"
end
