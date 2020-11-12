require 'net/http'

module KeycloakOauth
  class AuthorizableError < StandardError; end

  class AuthorizableService
    HTTP_SUCCESS_CODES = [Net::HTTPOK, Net::HTTPNoContent, Net::HTTPCreated]
    DEFAULT_CONTENT_TYPE = 'application/x-www-form-urlencoded'.freeze
    AUTHORIZATION_HEADER = 'Authorization'.freeze

    private

    def parsed_response(http_response)
      response = http_response.body.present? ? JSON.parse(http_response.body) : http_response.body

      return response if HTTP_SUCCESS_CODES.include?(http_response.code_type)

      # TODO: For now, we assume that the access token is always valid.
      # We do not yet handle the case where a refresh token is passed in and
      # used if the access token has expired.
      raise KeycloakOauth::AuthorizableError.new(error_message_from(response))
    end

    def error_message_from(response)
      # Keycloak sometimes sends back a hash containing the "errorMessage" key,
      # other times it returns a hash containing the "error_description key" key
      # and other times it returns an empty string. There could be more cases,
      # but for the moment we are only handling these three.
      case response.class.to_s
      when 'Hash'
        if response.has_key?('errorMessage')
          return response['errorMessage']
        elsif response.has_key?('error_description')
          return response['error_description']
        end
      when 'String'
        return response
      else
        'Unexpected Keycloak error'
      end
    end
  end
end
