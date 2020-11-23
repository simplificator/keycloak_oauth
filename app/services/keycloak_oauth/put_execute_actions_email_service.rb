require 'net/http'

module KeycloakOauth
  class PutExecuteActionsEmailService < KeycloakOauth::AuthorizableService
    SUPPORTED_QUERY_PARAMS = %i(client_id lifespan redirect_uri)

    attr_reader :connection, :user_id, :actions, :options

    def initialize(connection: KeycloakOauth.connection, access_token:, refresh_token:, user_id:, actions:, options: {})
      @connection = connection
      @access_token = access_token
      @refresh_token = refresh_token
      @user_id = user_id
      @actions = actions
      @options = options
    end

    def send_request
      put_execute_actions_email
    end

    private

    attr_accessor :access_token, :refresh_token

    def put_execute_actions_email
      uri = build_uri

      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        request = Net::HTTP::Put.new(uri)
        request.set_content_type(CONTENT_TYPE_JSON)
        request[AUTHORIZATION_HEADER] = "Bearer #{access_token}"
        request.body = actions.to_json
        req = http.request(request)
        req
      end
    end

    def build_uri
      self.class.uri_with_supported_query_params(
        connection.put_execute_actions_email_endpoint(user_id),
        SUPPORTED_QUERY_PARAMS,
        options
      )
    end

    def parse_response_body(http_response)
      super
    rescue KeycloakOauth::AuthorizableError => exception
      raise exception unless not_found_error?(exception)
      raise KeycloakOauth::NotFoundError.new(exception)
    end

    def not_found_error?(exception)
      exception.message == "User not found"
    end
  end
end
