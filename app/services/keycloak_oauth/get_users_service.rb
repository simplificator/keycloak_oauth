require 'net/http'

module KeycloakOauth
  class GetUsersService < KeycloakOauth::AuthorizableService
    SUPPORTED_QUERY_PARAMS = %i(briefRepresentation email first firstName lastName max search username)

    attr_reader :connection, :options

    def initialize(connection:, access_token:, refresh_token:, options: {})
      @connection = connection
      @access_token = access_token
      @refresh_token = refresh_token
      @options = options
    end

    def send_request
      get_users
    end

    private

    attr_reader :access_token, :refresh_token

    def get_users
      uri = build_uri

      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        request = Net::HTTP::Get.new(uri)
        request[AUTHORIZATION_HEADER] = "Bearer #{access_token}"
        http.request(request)
      end
    end

    def build_uri
      self.class.uri_with_supported_query_params(
        connection.users_endpoint,
        SUPPORTED_QUERY_PARAMS,
        options
      )
    end
  end
end
