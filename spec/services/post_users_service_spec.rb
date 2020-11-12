require 'rails_helper'
require 'support/helpers/keycloak_responses'

RSpec.describe KeycloakOauth::PostUsersService do
  include Helpers::KeycloakResponses

  describe '#send_request' do
    context 'when the user was created on Keycloak' do
      it 'performs request' do
        stub_request(:post, 'http://domain/auth/admin/realms/first_realm/users')
          .with(body: dummy_user_params_as_json)
          .to_return(status: [201], body: nil) # Keycloak replies with an empty body.

        service = KeycloakOauth::PostUsersService.new(
          access_token: 'access_token',
          refresh_token: 'refresh_token',
          connection: KeycloakOauth.connection,
          user_params: {
            firstName: 'TestUser',
            lastName: 'TestUser',
            email: 'testuser@example.com',
            username: 'testuser@example.com'
          }
        )

        response = service.send_request
        expect(response).to be_empty
      end
    end
  end

  private

  def dummy_user_params_as_json
    "{\"firstName\":\"TestUser\",\"lastName\":\"TestUser\",\"email\":" \
    "\"testuser@example.com\",\"username\":\"testuser@example.com\"}"
  end
end
