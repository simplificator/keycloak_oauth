require 'net/http'

module KeycloakOauth
  class UserInfoRetrievalError < StandardError; end

  class UserInfoRetrievalService
    AUTHORIZATION_HEADER = 'Authorization'.freeze
    CONTENT_TYPE = 'application/x-www-form-urlencoded'.freeze

    attr_reader :user_information

    def initialize(access_token:)
      @access_token = access_token
    end

    def retrieve
      @user_information = parsed_user_information(get_user)
    end

    private

    attr_accessor :access_token

    def get_user
      uri = URI.parse(KeycloakOauth.connection.user_info_endpoint)
      Net::HTTP.start(uri.host, uri.port) do |http|
        request = Net::HTTP::Get.new(uri)
        request.set_content_type(CONTENT_TYPE)
        request[AUTHORIZATION_HEADER] = "Bearer #{access_token}"
        http.request(request)
      end
    end

    def parsed_user_information(http_response)
      response_hash = JSON.parse(http_response.body)

      return response_hash if http_response.code_type == Net::HTTPOK

      # TODO: For now, we assume that the access token is always valid.
      # We do not yet handle the case where a refresh token is passed in and
      # used if the access token has expired.
      raise KeycloakOauth::UserInfoRetrievalError.new(response_hash)
    end
  end
end
