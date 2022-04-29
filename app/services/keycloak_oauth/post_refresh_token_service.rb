require 'net/http'

module KeycloakOauth
  class PostRefreshTokenService < KeycloakOauth::AuthorizableService
    DEFAULT_GRANT_TYPE = 'refresh_token'.freeze

    attr_reader :request_params, :connection

    def initialize(connection:, refresh_token:)
      @connection = connection
      @refresh_token = refresh_token
    end

    def send_request
      post_token
    end

    private

    attr_reader :connection, :refresh_token

    def post_token
      uri = URI.parse(connection.authentication_endpoint)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        request = Net::HTTP::Post.new(uri)
        request.set_content_type(CONTENT_TYPE_X_WWW_FORM_URLENCODED)
        request.set_form_data(token_request_params)
        http.request(request)
      end
    end

    def token_request_params
      {
        client_id: connection.client_id,
        client_secret: connection.client_secret,
        grant_type: DEFAULT_GRANT_TYPE,
        refresh_token: @refresh_token
      }
    end
  end
end
