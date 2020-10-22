module KeycloakOauth
  class Connection
    attr_reader :auth_url, :realm, :client_id, :client_secret, :callback_module

    DEFAULT_RESPONSE_TYPE = 'code'.freeze

    def initialize(auth_url:, realm:, client_id:, client_secret:, callback_module: nil)
      @auth_url = auth_url
      @realm = realm
      @client_id = client_id
      @client_secret = client_secret
      @callback_module = callback_module
    end

    def authorization_endpoint(options: {})
      endpoint = "#{auth_url}/realms/#{realm}/protocol/openid-connect/auth?client_id=#{client_id}"
      endpoint += "&response_type=#{options[:response_type] || DEFAULT_RESPONSE_TYPE}"
    end
  end
end
