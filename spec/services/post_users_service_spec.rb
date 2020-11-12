require 'rails_helper'
require 'support/helpers/keycloak_responses'

RSpec.describe KeycloakOauth::PostUsersService do
  include Helpers::KeycloakResponses

  describe '#send_request' do
    subject do
      KeycloakOauth::PostUsersService.new(
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
    end

    context 'when the user was created on Keycloak' do
      it 'performs request' do
        stub_request(:post, 'http://domain/auth/admin/realms/first_realm/users')
          .with(body: dummy_user_params_as_json)
          .to_return(status: [201], body: nil) # Keycloak replies with an empty body.


        response = subject.send_request
        expect(response).to be_empty
      end
    end

    context 'when Keycloak returned an error' do
      context 'when a user with this email already exists' do
        it 'raises an EmailConflictError' do
          stub_request(:post, 'http://domain/auth/admin/realms/first_realm/users')
            .with(body: dummy_user_params_as_json)
            .to_return(status: [409], body: email_conflict_error_as_json)

          expect { subject.send_request }.to raise_error(KeycloakOauth::EmailConflictError)
        end
      end

      context 'when the access token has expired' do
        it 'raises an AuthorizableError' do
          stub_request(:post, 'http://domain/auth/admin/realms/first_realm/users')
            .with(body: dummy_user_params_as_json)
            .to_return(status: [401], body: keycloak_invalid_token_request_error_body)

          expect { subject.send_request }.to raise_error(KeycloakOauth::AuthorizableError)
        end
      end
    end
  end

  private

  def dummy_user_params_as_json
    "{\"firstName\":\"TestUser\",\"lastName\":\"TestUser\",\"email\":" \
    "\"testuser@example.com\",\"username\":\"testuser@example.com\"}"
  end

  def email_conflict_error_as_json
    "{\"errorMessage\":\"User exists with same email\"}"
  end
end
