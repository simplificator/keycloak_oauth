module KeycloakOauth
  class CallbacksController < ApplicationController
    include KeycloakOauth.connection.callback_module

    def openid_connect
      after_sign_in_path(request)
    end
  end
end
