require 'net/http'

module KeycloakOauth
  class AuthorizableError < StandardError; end
  class NotFoundError < StandardError; end

  class AuthorizableService
    HTTP_SUCCESS_CODES = [Net::HTTPOK, Net::HTTPNoContent, Net::HTTPCreated]
    CONTENT_TYPE_X_WWW_FORM_URLENCODED = 'application/x-www-form-urlencoded'.freeze
    CONTENT_TYPE_JSON = 'application/json'.freeze
    AUTHORIZATION_HEADER = 'Authorization'.freeze

    attr_reader :http_response, :parsed_response_body

    def perform
      @http_response = send_request
      @parsed_response_body ||= parse_response_body(http_response)
    end

    def self.uri_with_supported_query_params(url, supported_params, given_params)
      uri = URI.parse(url)

      query_params = supported_params.inject({}) do |acc, query_param|
        acc[query_param] = given_params[query_param] if given_params[query_param].present?
        acc
      end

      uri.query = URI.encode_www_form(query_params) if query_params.values.any?
      uri
    end

    private

    def parse_response_body(http_response)
      response_body = http_response.body.present? ? JSON.parse(http_response.body) : http_response.body

      return response_body if HTTP_SUCCESS_CODES.include?(http_response.code_type)

      # TODO: For now, we assume that the access token is always valid.
      # We do not yet handle the case where a refresh token is passed in and
      # used if the access token has expired.
      raise KeycloakOauth::AuthorizableError.new(error_message_from(response_body))
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
        elsif response.has_key?('error')
          return response['error']
        end
      when 'String'
        return response
      else
        'Unexpected Keycloak error'
      end
    end
  end
end
