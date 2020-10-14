module KeycloakOauth
  module Models
    class Connection
      attr_accessor :auth_url, :realm, :client_id, :client_secret

      DEFAULT_RESPONSE_TYPE = 'code'.freeze

      def initialize(auth_url:, realm:, client_id:, client_secret:)
        @auth_url = auth_url
        @realm = realm
        @client_id = client_id
        @client_secret = client_secret
      end

      def authorization_endpoint(options: {})
        endpoint = "#{auth_url}/realms/#{realm}/protocol/openid-connect/auth?client_id=#{client_id}"
        endpoint += "&response_type=#{options[:response_type] || DEFAULT_RESPONSE_TYPE}"
      end
    end
  end
end
