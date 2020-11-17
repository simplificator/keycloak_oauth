require 'net/http'

module KeycloakOauth
  class DuplicationError < StandardError; end

  class PostUsersService < KeycloakOauth::AuthorizableService
    CONTENT_TYPE = 'application/json'.freeze

    attr_reader :request_params, :connection, :user_params

    def initialize(connection:, access_token:, refresh_token:, user_params:)
      @connection = connection
      @access_token = access_token
      @refresh_token = refresh_token
      @user_params = user_params
    end

    def send_request
      post_users
    end

    private

    attr_accessor :access_token, :refresh_token

    def post_users
      uri = URI.parse(connection.post_users_endpoint)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        request = Net::HTTP::Post.new(uri)
        request.set_content_type(CONTENT_TYPE)
        request[AUTHORIZATION_HEADER] = "Bearer #{access_token}"
        request.body = user_params.to_json
        http.request(request)
      end
    end

    def parse_response_body(http_response)
      super
    rescue KeycloakOauth::AuthorizableError => exception
      raise exception unless is_exception_a_duplication?(exception)
      raise KeycloakOauth::DuplicationError.new(exception)
    end

    def is_exception_a_duplication?(exception)
      exception.message == "User exists with same email" ||
      exception.message == "User exists with same username"
    end
  end
end
