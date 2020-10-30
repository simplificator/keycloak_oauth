require 'net/http'

module KeycloakOauth
  class AuthenticationError < StandardError; end

  class AuthenticationService
    GRANT_TYPE = 'authorization_code'.freeze
    CONTENT_TYPE = 'application/x-www-form-urlencoded'.freeze
    ACCESS_TOKEN_KEY = 'access_token'.freeze
    REFRESH_TOKEN_KEY = 'refresh_token'.freeze

    attr_reader :session

    def initialize(authentication_params:, session:, redirect_uri:)
      @code = authentication_params[:code]
      @session = session
      @redirect_uri = redirect_uri
    end

    def authenticate
      store_credentials(get_tokens)
    end

    private

    attr_reader :code, :redirect_uri

    def get_tokens
      uri = URI.parse(KeycloakOauth.connection.authentication_endpoint)
      Net::HTTP.start(uri.host, uri.port) do |http|
        request = Net::HTTP::Post.new(uri)
        request.set_content_type(CONTENT_TYPE)
        request.set_form_data(token_request_params)
        http.request(request)
      end
    end

    def token_request_params
      {
        client_id: KeycloakOauth.connection.client_id,
        client_secret: KeycloakOauth.connection.client_secret,
        grant_type: GRANT_TYPE,
        code: code,
        redirect_uri: redirect_uri
      }
    end

    def store_credentials(http_response)
      response_hash = JSON.parse(http_response.body)

      if http_response.code_type == Net::HTTPOK
        session[:access_token] = response_hash[ACCESS_TOKEN_KEY]
        session[:refresh_token] = response_hash[REFRESH_TOKEN_KEY]
      else
        raise KeycloakOauth::AuthenticationError.new(response_hash)
      end
    end
  end
end
