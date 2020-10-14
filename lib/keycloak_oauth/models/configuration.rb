require 'singleton'

module KeycloakOauth
  module Models
    class Configuration
      include Singleton

      attr_accessor :auth_url, :realm, :client_id, :client_secret
    end
  end
end
