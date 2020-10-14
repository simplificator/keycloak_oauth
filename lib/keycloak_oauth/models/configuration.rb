require 'singleton'

module KeycloakOauth
  module Models
    class Configuration
      include Singleton

      attr_accessor :auth_url
      attr_accessor :realm
      attr_accessor :client_id
      attr_accessor :client_secret
    end
  end
end
