require 'keycloak_oauth/version'
require 'keycloak_oauth/models/configuration'
require 'keycloak_oauth/models/connection'
require 'byebug'

module KeycloakOauth
  def self.configure
    yield(configuration) if block_given?
  end

  def self.configuration
    Models::Configuration.instance
  end

  def self.connection
    @connection ||= KeycloakOauth::Models::Connection.new(
      auth_url: configuration.auth_url,
      realm: configuration.realm,
      client_id: configuration.client_id,
      client_secret: configuration.client_secret
    )
  end
end
