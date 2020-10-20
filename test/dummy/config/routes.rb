Rails.application.routes.draw do
  mount KeycloakOauth::Engine => "/keycloak_oauth"

  get 'first_page' => 'pages#first_page'
  get 'second_page' => 'pages#second_page'

  root to: '/'
end
