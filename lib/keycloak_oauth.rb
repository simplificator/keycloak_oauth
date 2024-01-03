require_relative 'keycloak_oauth/version'
require_relative 'keycloak_oauth/configuration'
require_relative 'keycloak_oauth/connection'
require_relative 'keycloak_oauth/engine'

module KeycloakOauth
  def self.configure
    yield(configuration) if block_given?
  end

  def self.configuration
    Configuration.instance
  end

  def self.connection
    @connection ||= KeycloakOauth::Connection.new(
      auth_url: configuration.auth_url,
      realm: configuration.realm,
      client_id: configuration.client_id,
      client_secret: configuration.client_secret,
      callback_module: configuration.callback_module
    )
  end
end
