KeycloakOauth.configure do |config|
  config.auth_url = 'http://domain/auth'
  config.realm = 'first_realm'
  config.client_id = 'a_client'
  config.client_secret = 'a_secret'
  config.callback_module = KeycloakOauthCallbacks
end
