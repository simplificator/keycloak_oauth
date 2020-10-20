KeycloakOauth::Engine.routes.draw do
  get 'openid_connect', to: 'callbacks#openid_connect'
end
