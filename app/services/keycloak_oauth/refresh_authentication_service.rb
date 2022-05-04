module KeycloakOauth
  class RefreshAuthenticationService < AuthenticationServiceBase

    def initialize(session:)
      super
    end

    private

    def post_service_name
      KeycloakOauth::PostRefreshTokenService
    end

    def post_service_arguments
      {
        connection: KeycloakOauth.connection,
        refresh_token: session[:refresh_token]
      }
    end
  end
end
