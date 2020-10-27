module KeycloakOauth
  class CallbacksController < ApplicationController
    if KeycloakOauth.connection.callback_module.present?
      include KeycloakOauth.connection.callback_module
    end

    def oauth2
      authentication_service = KeycloakOauth::AuthenticationService.new(
        authentication_params: authentication_params,
        session: session
      )
      authentication_service.authenticate

      redirect_to self.class.method_defined?(:after_sign_in_path) ? after_sign_in_path(request) : '/'
    end

    private

    def authentication_params
      params.permit(:code)
    end
  end
end
