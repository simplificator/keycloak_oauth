module KeycloakOauthCallbacks
  extend ActiveSupport::Concern

  included do
    include Rails.application.routes.url_helpers
  end

  def after_sign_in_path(request)
    request.params[:show_first_page].present? ? first_page_path : second_page_path
  end

  def map_authenticatable(_request)
    user_info = KeycloakOauth.connection.get_user_information(access_token: session[:access_token])
    session[:user_email_address] = user_info['email']
  end
end
