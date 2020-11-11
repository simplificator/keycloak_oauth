require 'net/http'

module KeycloakOauth
  class PostTokenService
    DEFAULT_GRANT_TYPE = 'authorization_code'.freeze
    CONTENT_TYPE = 'application/x-www-form-urlencoded'.freeze

    attr_reader :request_params, :connection

    def initialize(connection:, request_params:)
      @connection = connection
      @request_params = request_params
    end

    def send_request
      post_token
    end

    private

    attr_reader :code, :redirect_uri

    def post_token
      uri = URI.parse(connection.authentication_endpoint)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        request = Net::HTTP::Post.new(uri)
        request.set_content_type(CONTENT_TYPE)
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
