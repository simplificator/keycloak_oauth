require 'net/http'

module KeycloakOauth
  class AuthorizableError < StandardError; end

  class AuthorizableService
    HTTP_SUCCESS_CODES = [Net::HTTPOK, Net::HTTPNoContent]
    DEFAULT_CONTENT_TYPE = 'application/x-www-form-urlencoded'.freeze
    AUTHORIZATION_HEADER = 'Authorization'.freeze

    private

    def parsed_response(http_response)
      response = http_response.body.present? ? JSON.parse(http_response.body) : http_response.body

      return response if HTTP_SUCCESS_CODES.include?(http_response.code_type)

      # TODO: For now, we assume that the access token is always valid.
      # We do not yet handle the case where a refresh token is passed in and
      # used if the access token has expired.
      raise KeycloakOauth::AuthorizableError.new(response)
    end
  end
end