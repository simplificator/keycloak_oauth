require 'net/http'

module KeycloakOauth
  class PostAuthorizationCodeService < KeycloakOauth::AuthorizableService
    DEFAULT_GRANT_TYPE = 'authorization_code'.freeze

    attr_reader :request_params, :connection

    def initialize(connection:, access_token: nil, refresh_token: nil, request_params:)
      @connection = connection
      @access_token = access_token
      @refresh_token = refresh_token
      @request_params = request_params
    end

    def send_request
      post_token
    end

    private

    attr_reader :code, :redirect_uri, :access_token, :refresh_token

    def post_token
      uri = URI.parse(connection.authentication_endpoint)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        request = Net::HTTP::Post.new(uri)
        request[AUTHORIZATION_HEADER] = "Bearer #{access_token}" if access_token.present?
        request.set_content_type(CONTENT_TYPE_X_WWW_FORM_URLENCODED)
        request.set_form_data(token_request_params)
        http.request(request)
      end
    end

    def token_request_params
      {
        client_id: connection.client_id,
        client_secret: connection.client_secret,
        grant_type: DEFAULT_GRANT_TYPE
      }.merge(request_params)
    end
  end
end
