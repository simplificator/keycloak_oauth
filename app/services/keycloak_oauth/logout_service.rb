require 'net/http'

module KeycloakOauth
  class LogoutService < KeycloakOauth::AuthorizableService
    def logout
      parsed_response(post_logout)
    end

    private

    def post_logout
      uri = URI.parse(KeycloakOauth.connection.logout_endpoint)
      Net::HTTP.start(uri.host, uri.port) do |http|
        request = Net::HTTP::Post.new(uri)
        request.set_content_type(DEFAULT_CONTENT_TYPE)
        request[AUTHORIZATION_HEADER] = "Bearer #{access_token}"
        http.request(request)
      end
    end
  end
end
