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
      map_authenticatable_if_implemented(session)

      redirect_to self.class.method_defined?(:after_sign_in_path) ? after_sign_in_path(request) : '/'
    end

    private

    def authentication_params
      params.permit(:code)
    end

    def map_authenticatable_if_implemented(request)
      if self.class.method_defined?(:map_authenticatable)
        map_authenticatable(request)
      else
        raise NotImplementedError.new('User mapping must be handled by the host app. See README for more information.')
      end
    end
  end
end
