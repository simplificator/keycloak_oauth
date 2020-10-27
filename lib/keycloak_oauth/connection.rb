require 'keycloak_oauth/endpoints'

module KeycloakOauth
  class Connection
    include KeycloakOauth::Endpoints

    attr_reader :auth_url, :realm, :client_id, :client_secret, :callback_module

    def initialize(auth_url:, realm:, client_id:, client_secret:, callback_module: nil)
      @auth_url = auth_url
      @realm = realm
      @client_id = client_id
      @client_secret = client_secret
      @callback_module = callback_module
    end
  end
end
