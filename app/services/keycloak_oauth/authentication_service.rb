module KeycloakOauth
  class AuthenticationService
    ACCESS_TOKEN_KEY = 'access_token'.freeze
    ACCESS_TOKEN_EXPIRES_IN = 'expires_in'.freeze
    REFRESH_TOKEN_KEY = 'refresh_token'.freeze
    REFRESH_TOKEN_EXPIRES_IN = 'refresh_expires_in'.freeze

    attr_reader :session, :authentication_params

    def initialize(authentication_params:, session:)
      @authentication_params = authentication_params
      @session = session
    end

    def authenticate
      request_time = Time.zone.now

      post_token_service = KeycloakOauth::PostAuthorizationCodeService.new(
        connection: KeycloakOauth.connection,
        request_params: authentication_params
      )
      post_token_service.perform
      store_credentials(post_token_service, request_time)
    end

    private

    def store_credentials(post_token_service, request_time)
      response_hash = post_token_service.parsed_response_body

      session[:access_token] = response_hash[ACCESS_TOKEN_KEY]
      session[:refresh_token] = response_hash[REFRESH_TOKEN_KEY]

      session[:access_token_expires_at] = request_time + response_hash[ACCESS_TOKEN_EXPIRES_IN].to_i.seconds
      session[:refresh_token_expires_at] = request_time + response_hash[REFRESH_TOKEN_EXPIRES_IN].to_i.seconds
    end
  end
end
