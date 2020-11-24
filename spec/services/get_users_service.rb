require 'rails_helper'
require 'support/helpers/keycloak_responses'

RSpec.describe KeycloakOauth::GetUsersService do
  include Helpers::KeycloakResponses

  let(:service) do
    KeycloakOauth::GetUsersService.new(
      connection: KeycloakOauth.connection,
      access_token: access_token,
      refresh_token: refresh_token
    )
  end

  describe '#perform' do
    subject { service.perform }

    context 'when the users can be retrieved from Keycloak' do
      context 'when no filtering options are passed in' do
        it 'retrieves all users' do
          stub_request(:get, 'http://domain/auth/admin/realms/first_realm/users')
            .to_return(status: [200], body: keycloak_users_request_body)

          subject

          expect(service.http_response.code_type).to eq(Net::HTTPOK)
          expect(service.parsed_response_body).to eq([{
            'id' => 'fd62fb4e-04e1-4660-a961-f4592b95bb45',
            'createdTimestamp' => 1606123457175,
            'username' => 'user_A',
            'enabled' => true,
            'totp' => false,
            'emailVerified' => false,
            'firstName' => 'User A First Name',
            'lastName' => 'User A Last Name',
            'email' => 'user_A@example.com',
            'disableableCredentialTypes' => [],
            'requiredActions' => [],
            'notBefore' => 0,
            'access' => {
              'manageGroupMembership' => true,
              'view' => true,
              'mapRoles' => true,
              'impersonate' => false,
              'manage' => true
              }
            }]
          )
        end
      end

      context 'when some filtering options are passed in' do
        let(:service) do
          KeycloakOauth::GetUsersService.new(
            connection: KeycloakOauth.connection,
            access_token: access_token,
            refresh_token: refresh_token,
            options: { username: 'user_A', email: 'user_A@example.com' }
          )
        end

        it 'passes options to Keycloak' do
          url = 'http://domain/auth/admin/realms/first_realm/users?username=user_A' \
                '&email=user_A@example.com'

          stub_request(:get, url)
            .to_return(status: [200], body: keycloak_users_request_body)

          subject

          expect(service.http_response.code_type).to eq(Net::HTTPOK)
          expect(service.parsed_response_body).to eq([{
            'id' => 'fd62fb4e-04e1-4660-a961-f4592b95bb45',
            'createdTimestamp' => 1606123457175,
            'username' => 'user_A',
            'enabled' => true,
            'totp' => false,
            'emailVerified' => false,
            'firstName' => 'User A First Name',
            'lastName' => 'User A Last Name',
            'email' => 'user_A@example.com',
            'disableableCredentialTypes' => [],
            'requiredActions' => [],
            'notBefore' => 0,
            'access' => {
              'manageGroupMembership' => true,
              'view' => true,
              'mapRoles' => true,
              'impersonate' => false,
              'manage' => true
              }
            }]
          )
        end
      end

      context 'when some unsupported filtering options are passed in' do
        let(:service) do
          KeycloakOauth::GetUsersService.new(
            connection: KeycloakOauth.connection,
            access_token: access_token,
            refresh_token: refresh_token,
            options: { unsupported_param: 'user_A' }
          )
        end

        it 'does not pass unsupported filters to Keycloak' do
          stub_request(:get, 'http://domain/auth/admin/realms/first_realm/users')
            .to_return(status: [200], body: keycloak_users_request_body)

          subject

          expect(service.http_response.code_type).to eq(Net::HTTPOK)
          expect(service.parsed_response_body).to eq([{
            'id' => 'fd62fb4e-04e1-4660-a961-f4592b95bb45',
            'createdTimestamp' => 1606123457175,
            'username' => 'user_A',
            'enabled' => true,
            'totp' => false,
            'emailVerified' => false,
            'firstName' => 'User A First Name',
            'lastName' => 'User A Last Name',
            'email' => 'user_A@example.com',
            'disableableCredentialTypes' => [],
            'requiredActions' => [],
            'notBefore' => 0,
            'access' => {
              'manageGroupMembership' => true,
              'view' => true,
              'mapRoles' => true,
              'impersonate' => false,
              'manage' => true
              }
            }]
          )
        end
      end
    end

    context 'when no users are found in Keycloak' do
      it 'returns an empty array' do
        stub_request(:get, 'http://domain/auth/admin/realms/first_realm/users')
          .to_return(status: [200], body: "[]")

        subject

        expect(service.http_response.code_type).to eq(Net::HTTPOK)
        expect(service.parsed_response_body).to be_empty
      end
    end

    context 'when the access token is invalid' do
      let(:access_token) { 'some_token' }

      it 'raises an error' do
        stub_request(:get, 'http://domain/auth/admin/realms/first_realm/users').
          to_return(status: [401], body: keycloak_invalid_token_request_error_body)

        expect { subject }.to raise_error(KeycloakOauth::AuthorizableError)
      end
    end
  end
end
