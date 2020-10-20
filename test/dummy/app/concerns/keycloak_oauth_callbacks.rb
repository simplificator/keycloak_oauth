module KeycloakOauthCallbacks
  extend ActiveSupport::Concern

  included do
    include Rails.application.routes.url_helpers
  end

  def after_sign_in_path(request)
    request.params[:show_first_page].present? ? first_page_path : second_page_path
  end
end