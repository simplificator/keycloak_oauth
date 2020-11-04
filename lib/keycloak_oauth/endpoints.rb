module KeycloakOauth
  module Endpoints
    DEFAULT_RESPONSE_TYPE = 'code'.freeze

    def authorization_endpoint(options: {})
      endpoint = "#{auth_url}/realms/#{realm}/protocol/openid-connect/auth?client_id=#{client_id}"
      endpoint += "&response_type=#{options[:response_type] || DEFAULT_RESPONSE_TYPE}"
      endpoint += "&redirect_uri=#{options[:redirect_uri]}" if options[:redirect_uri].present?
      endpoint
    end

    def authentication_endpoint
      "#{auth_url}/realms/#{realm}/protocol/openid-connect/token"
    end

    def user_info_endpoint
      "#{auth_url}/realms/#{realm}/protocol/openid-connect/userinfo"
    end

    def logout_endpoint
      "#{auth_url}/realms/#{realm}/protocol/openid-connect/logout"
    end
  end
end
