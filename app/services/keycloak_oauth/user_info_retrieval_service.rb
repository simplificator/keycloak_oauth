require 'net/http'

module KeycloakOauth
  class UserInfoRetrievalService < KeycloakOauth::AuthorizableService
    attr_reader :user_information

    def retrieve
      @user_information = parsed_response(get_user)
    end

    private

    def get_user
      uri = URI.parse(KeycloakOauth.connection.user_info_endpoint)
      Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        request = Net::HTTP::Get.new(uri)
        request.set_content_type(DEFAULT_CONTENT_TYPE)
        request[AUTHORIZATION_HEADER] = "Bearer #{access_token}"
        http.request(request)
      end
    end
  end
end
