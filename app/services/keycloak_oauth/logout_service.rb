require 'net/http'

module KeycloakOauth
  class LogoutService < KeycloakOauth::AuthorizableService
    def initialize(session)
      @session = session
    end

    def send_request
      post_logout
    end

    private

    attr_accessor :session

    def post_logout
      uri = URI.parse(KeycloakOauth.connection.logout_endpoint)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        request = Net::HTTP::Post.new(uri)
        request.set_content_type(DEFAULT_CONTENT_TYPE)
        request.set_form_data(logout_request_params)
        request[AUTHORIZATION_HEADER] = "Bearer #{access_token}"
        http.request(request)
      end
    end

    def logout_request_params
      {
        client_id: KeycloakOauth.connection.client_id,
        client_secret: KeycloakOauth.connection.client_secret,
        refresh_token: refresh_token
      }
    end

    def access_token
      session[:access_token]
    end

    def refresh_token
      session[:refresh_token]
    end
  end
end
