class SessionsController < ApplicationController
  def destroy
    KeycloakOauth.connection.logout(session: session)
    redirect_to first_page_path
  end
end
