module KeycloakOauth
  class CallbacksController < ApplicationController
    if KeycloakOauth.connection.callback_module.present?
      include KeycloakOauth.connection.callback_module
    end

    def openid_connect
      redirect_to self.class.method_defined?(:after_sign_in_path) ? after_sign_in_path(request) : '/'
    end
  end
end
