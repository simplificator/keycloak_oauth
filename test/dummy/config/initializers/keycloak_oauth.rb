KeycloakOauth.configure do |config|
  config.auth_url = 'auth_url'
  config.realm = 'realm'
  config.client_id = 'client_id'
  config.client_secret = 'client_secret'
  config.callback_module = KeycloakOauthCallbacks
end
