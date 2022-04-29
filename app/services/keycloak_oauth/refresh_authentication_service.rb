module KeycloakOauth
  class RefreshAuthenticationService
    ACCESS_TOKEN_KEY = 'access_token'.freeze
    ACCESS_TOKEN_EXPIRES_IN = 'expires_in'.freeze
    REFRESH_TOKEN_KEY = 'refresh_token'.freeze
    REFRESH_TOKEN_EXPIRES_IN = 'refresh_expires_in'.freeze

    attr_reader :session

    def initialize(session:)
      @session = session
    end

    def authenticate
      request_time = Time.zone.now

      post_refresh_token_service = KeycloakOauth::PostRefreshTokenService.new(
        connection: KeycloakOauth.connection,
        refresh_token: @session[:refresh_token]
      )
      post_refresh_token_service.perform
      update_session_information(post_refresh_token_service, request_time)
    end

    private

    def update_session_information(post_token_service, request_time)
      response_hash = post_token_service.parsed_response_body

      session[:access_token] = response_hash[ACCESS_TOKEN_KEY]
      session[:refresh_token] = response_hash[REFRESH_TOKEN_KEY]

      session[:access_token_expires_in] = request_time + response_hash[ACCESS_TOKEN_EXPIRES_IN].to_i.seconds
      session[:refresh_token_expires_in] = request_time + response_hash[REFRESH_TOKEN_EXPIRES_IN].to_i.seconds
    end
  end
end
