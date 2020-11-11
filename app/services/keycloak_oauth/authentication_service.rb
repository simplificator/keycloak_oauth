module KeycloakOauth
  class AuthenticationError < StandardError; end

  class AuthenticationService
    ACCESS_TOKEN_KEY = 'access_token'.freeze
    REFRESH_TOKEN_KEY = 'refresh_token'.freeze

    attr_reader :session, :authentication_params

    def initialize(authentication_params:, session:)
      @authentication_params = authentication_params
      @session = session
    end

    def authenticate
      post_token_service = KeycloakOauth::PostTokenService.new(
        connection: KeycloakOauth.connection,
        request_params: authentication_params
      )
      store_credentials(post_token_service.send_request)
    end

    private

    def store_credentials(http_response)
      response_hash = JSON.parse(http_response.body)

      if http_response.code_type == Net::HTTPOK
        session[:access_token] = response_hash[ACCESS_TOKEN_KEY]
        session[:refresh_token] = response_hash[REFRESH_TOKEN_KEY]
      else
        raise KeycloakOauth::AuthenticationError.new(response_hash)
      end
    end
  end
end
