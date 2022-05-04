module KeycloakOauth
  class AuthenticationService < AuthenticationServiceBase

    attr_reader :authentication_params

    def initialize(session:, authentication_params:)
      @authentication_params = authentication_params
      super session: session
    end

    private

    def post_service_name
      KeycloakOauth::PostAuthorizationCodeService
    end

    def post_service_arguments
      {
        connection: KeycloakOauth.connection,
        request_params: authentication_params
      }
    end
  end
end
