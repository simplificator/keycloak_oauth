module KeycloakOauth
  module Views
    class Login
      def self.button
        '<a href=http://TBA/auth/realms/TBA/protocol/openid-connect/auth?client_id=TBA&response_type=code>Login with Keycloak</a>'
      end
    end
  end
end
