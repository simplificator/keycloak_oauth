module KeycloakOauthCallbacks
  extend ActiveSupport::Concern

  included do
    include Rails.application.routes.url_helpers
  end

  def after_sign_in_path(request)
    request.params[:show_first_page].present? ? first_page_path : second_page_path
  end

  def map_authenticatable(_request)
    service = KeycloakOauth::UserInfoRetrievalService.new(access_token: session[:access_token])
    service.retrieve
    session[:user_email_address] = service.user_information['email']
  end
end
