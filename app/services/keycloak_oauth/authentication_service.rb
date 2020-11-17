module KeycloakOauth
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
      post_token_service.perform
      store_credentials(post_token_service)
    end

    private

    def store_credentials(post_token_service)
      response_hash = post_token_service.parsed_response_body

      session[:access_token] = response_hash[ACCESS_TOKEN_KEY]
      session[:refresh_token] = response_hash[REFRESH_TOKEN_KEY]
    end
  end
end
