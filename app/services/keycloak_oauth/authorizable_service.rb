require 'net/http'

module KeycloakOauth
  class AuthorizableError < StandardError; end

  class AuthorizableService
    DEFAULT_CONTENT_TYPE = 'application/x-www-form-urlencoded'.freeze
    AUTHORIZATION_HEADER = 'Authorization'.freeze

    def initialize(access_token:)
      @access_token = access_token
    end

    private

    attr_accessor :access_token

    def parsed_response(http_response)
      response_hash = JSON.parse(http_response.body)

      return response_hash if http_response.code_type == Net::HTTPOK

      # TODO: For now, we assume that the access token is always valid.
      # We do not yet handle the case where a refresh token is passed in and
      # used if the access token has expired.
      raise KeycloakOauth::AuthorizableError.new(response_hash)
    end
  end
end
