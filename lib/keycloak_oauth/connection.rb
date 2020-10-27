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

    def get_user_information(access_token:)
      service = KeycloakOauth::UserInfoRetrievalService.new(access_token: access_token)
      service.retrieve
      service.user_information
    end
  end
end
