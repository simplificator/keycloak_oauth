require 'rails_helper'
require 'support/helpers/keycloak_responses'

RSpec.describe KeycloakOauth::PostAuthorizationCodeService do
  include Helpers::KeycloakResponses

  let(:service) do
    KeycloakOauth::PostRefreshTokenService.new(
      connection: connection,
      refresh_token: refresh_token
    )
  end

  describe '#send_request' do
    let(:connection) { KeycloakOauth.connection }

    subject { service.perform }

    context 'when the refresh token can be exchanged for an access token' do
      it 'retrieves authentication information' do
        stub_request(:post, 'http://domain/auth/realms/first_realm/protocol/openid-connect/token')
          .with(body: {
                  client_id: 'a_client',
                  client_secret: 'a_secret',
                  grant_type: 'refresh_token',
                  refresh_token: refresh_token
                }).to_return(body: keycloak_refresh_token_request_body)

        subject

        expect(service.http_response.code_type).to eq(Net::HTTPOK)
        expect(service.parsed_response_body).to eq(
          {
            'access_token' => access_token,
            'expires_in' => 32765,
            'refresh_expires_in' => 1800,
            'refresh_token' => refresh_token,
            'token_type' => 'Bearer',
            'not-before-policy' => 0,
            'session_state' => 'e4567259-6c07-4dd1-800b-d01692ed2634',
            'scope' => 'email profile'
          }
        )
      end
    end

    context 'when the refresh token is invalid/has expired' do
      it 'returns error' do
        faulty_service = KeycloakOauth::PostRefreshTokenService.new(
          connection: connection,
          refresh_token: 'refresh_token'
        )

        stub_request(:post, 'http://domain/auth/realms/first_realm/protocol/openid-connect/token')
          .with(body: {
                  client_id: 'a_client',
                  client_secret: 'a_secret',
                  grant_type: 'refresh_token',
                  refresh_token: 'refresh_token'
                }).to_return(status: [400], body: keycloak_invalid_refresh_token_error_body)

        expect { faulty_service.perform }.to raise_error(KeycloakOauth::AuthorizableError)
      end
    end

    context 'when some default params are overridden' do
      let(:dummy_request_params) { { grant_type: 'client_credentials' } }
      let(:connection) do
        KeycloakOauth::Connection.new(
          auth_url: 'http://domain/auth',
          realm: 'master',
          client_id: 'admin-cli',
          client_secret: 'some-admin-secret'
        )
      end

      it 'retrieves authentication information' do
        stub_request(:post, 'http://domain/auth/realms/master/protocol/openid-connect/token')
          .with(body: {
                  client_id: 'admin-cli',
                  client_secret: 'some-admin-secret',
                  grant_type: 'refresh_token',
                  refresh_token: refresh_token
                }).to_return(body: keycloak_refresh_token_request_body)

        subject

        expect(service.http_response.code_type).to eq(Net::HTTPOK)
        expect(service.parsed_response_body).to eq(
          {
            'access_token' => access_token,
            'expires_in' => 32765,
            'refresh_expires_in' => 1800,
            'refresh_token' => refresh_token,
            'token_type' => 'Bearer',
            'not-before-policy' => 0,
            'session_state' => 'e4567259-6c07-4dd1-800b-d01692ed2634',
            'scope' => 'email profile'
          }
        )
      end
    end
  end
end
