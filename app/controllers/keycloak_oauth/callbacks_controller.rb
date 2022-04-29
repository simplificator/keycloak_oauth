module KeycloakOauth
  class CallbacksController < ::ApplicationController
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
      params.permit(:code).merge({ redirect_uri: current_uri_without_params })
    end

    def map_authenticatable_if_implemented(request)
      if self.class.method_defined?(:map_authenticatable)
        map_authenticatable(request)
      else
        raise NotImplementedError.new('User mapping must be handled by the host app. See README for more information.')
      end
    end

    def current_uri_without_params
      # If the host app has overwritten the route (e.g. to enable localised
      # callbacks), this ensures we are using the path coming from the host app
      # instead of the one coming from the engine.
      main_app.url_for(only_path: false, overwrite_params: nil)
    rescue ActionController::UrlGenerationError
      # If the host app does not override the oauth2 path, use the engine's path.
      oauth2_url
    end
  end
end
