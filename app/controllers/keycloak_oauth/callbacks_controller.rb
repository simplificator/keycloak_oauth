module KeycloakOauth
  class CallbacksController < ApplicationController
    include KeycloakOauth.connection.callback_class

    def openid_connect
      after_sign_in_path(request)
    end
  end
end
