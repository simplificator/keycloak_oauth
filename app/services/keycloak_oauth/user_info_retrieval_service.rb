require 'net/http'

module KeycloakOauth
  class UserInfoRetrievalService < KeycloakOauth::AuthorizableService
    attr_reader :user_information

    def initialize(access_token:, refresh_token:)
      @access_token = access_token
      @refresh_token = refresh_token
    end

    def send_request
      get_user
    end

    private

    attr_accessor :access_token, :refresh_token

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
