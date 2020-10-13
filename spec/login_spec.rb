require 'spec_helper'

RSpec.describe KeycloakOauth::Views::Login do
  it 'generates button' do
    expect(KeycloakOauth::Views::Login.login_button).to eq('<a href=http://TBA/auth/realms/TBA/protocol/openid-connect/auth?client_id=TBA&response_type=code>Login with Keycloak</a>')
  end
end