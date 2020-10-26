require 'net/http'

module KeycloakOauth
  class AuthenticationError < StandardError; end

  class AuthenticationService
    GRANT_TYPE = 'authorization_code'.freeze
    CONTENT_TYPE = 'application/x-www-form-urlencoded'.freeze
    ACCESS_TOKEN_KEY = 'access_token'.freeze

    attr_reader :code

    def initialize(authentication_params)
      @code = authentication_params[:code]
    end

    def authenticate
      store_credentials(get_tokens)
    end

    private

    def get_tokens
      uri = URI.parse(KeycloakOauth.connection.authentication_endpoint)
      Net::HTTP.start(uri.host, uri.port) do |http|
        request = Net::HTTP::Post.new(uri)
        request.set_content_type(CONTENT_TYPE)
        request.set_form_data(token_request_params)
        response = http.request(request)
        response
      end
    end

    def token_request_params
      {
        client_id: KeycloakOauth.connection.client_id,
        client_secret: KeycloakOauth.connection.client_secret,
        grant_type: GRANT_TYPE,
        code: code
      }
    end

    def store_credentials(http_response)
      response_hash = JSON.parse(http_response.body)

      if http_response.code_type == Net::HTTPOK
        # TODO
      else
        raise KeycloakOauth::AuthenticationError.new(response_hash)
      end
    end
  end
end
