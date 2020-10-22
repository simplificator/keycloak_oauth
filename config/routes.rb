KeycloakOauth::Engine.routes.draw do
  get 'oauth2', to: 'callbacks#oauth2'
end
