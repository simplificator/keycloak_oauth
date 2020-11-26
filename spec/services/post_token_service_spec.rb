require 'rails_helper'
require 'support/helpers/keycloak_responses'

RSpec.describe KeycloakOauth::PostTokenService do
  include Helpers::KeycloakResponses

  let(:service) do
    KeycloakOauth::PostTokenService.new(
      connection: connection,
      request_params: dummy_request_params
    )
  end

  describe '#send_request' do
    let(:connection) { KeycloakOauth.connection }

    subject { service.perform }

    context 'when the authorization code can be exchanged for an access token' do
      it 'retrieves authentication information' do
        stub_request(:post, 'http://domain/auth/realms/first_realm/protocol/openid-connect/token').
          with(body: {
            client_id: 'a_client',
            client_secret: 'a_secret',
            grant_type: 'authorization_code',
            code: dummy_request_params[:code],
            redirect_uri: dummy_request_params[:redirect_uri],
            session_state: dummy_request_params[:session_state]
          }).to_return(body: keycloak_tokens_request_body)

        subject

        expect(service.http_response.code_type).to eq(Net::HTTPOK)
        expect(service.parsed_response_body).to eq(
          {
            'access_token' => access_token,
            'expires_in' => 32765,
            'refresh_expires_in' => 1800,
            'refresh_token' => refresh_token,
            'token_type' => 'bearer',
            'not-before-policy' => 0,
            'session_state' => dummy_request_params[:session_state],
            'scope' => "profile email"
          }
        )
      end
    end

    context 'when the authorization code is invalid/has expired' do
      it 'returns error' do
        stub_request(:post, 'http://domain/auth/realms/first_realm/protocol/openid-connect/token').
          with(body: {
            client_id: 'a_client',
            client_secret: 'a_secret',
            grant_type: 'authorization_code',
            code: dummy_request_params[:code],
            redirect_uri: dummy_request_params[:redirect_uri],
            session_state: dummy_request_params[:session_state]
          }).to_return(status: [400], body: keycloak_invalid_code_request_error_body)

        expect { subject }.to raise_error(KeycloakOauth::AuthorizableError)
      end
    end

    context 'when some default params are overriden' do
      let(:dummy_request_params) { { grant_type: 'client_credentials' } }
      let(:connection) {
        KeycloakOauth::Connection.new(
          auth_url: 'http://domain/auth',
          realm: 'master',
          client_id: 'admin-cli',
          client_secret: 'some-admin-secret'
        )
      }

      it 'retrieves authentication information' do
        stub_request(:post, 'http://domain/auth/realms/master/protocol/openid-connect/token').
          with(body: {
            client_id: 'admin-cli',
            client_secret: 'some-admin-secret',
            grant_type: 'client_credentials'
          }).to_return(body: keycloak_tokens_request_body)

        subject

        expect(service.http_response.code_type).to eq(Net::HTTPOK)
        expect(service.parsed_response_body).to eq(
          {
            'access_token' => access_token,
            'expires_in' => 32765,
            'refresh_expires_in' => 1800,
            'refresh_token' => refresh_token,
            'token_type' => 'bearer',
            'not-before-policy' => 0,
            'session_state' => 'e4567259-6c07-4dd1-800b-d01692ed2634',
            'scope' => "profile email"
          }
        )
      end
    end

    context 'when an access token is passed in' do
      let(:service) do
        KeycloakOauth::PostTokenService.new(
          connection: connection,
          access_token: 'some_access_token',
          request_params: dummy_request_params
        )
      end

      it 'sets the Authorization header' do
        stub_request(:post, 'http://domain/auth/realms/first_realm/protocol/openid-connect/token')
          .with(headers: { 'Authorization' => 'Bearer some_access_token'})
          .to_return(body: keycloak_tokens_request_body)

        subject

        expect(service.http_response.code_type).to eq(Net::HTTPOK)
        expect(service.parsed_response_body).to eq(
          {
            'access_token' => access_token,
            'expires_in' => 32765,
            'refresh_expires_in' => 1800,
            'refresh_token' => refresh_token,
            'token_type' => 'bearer',
            'not-before-policy' => 0,
            'session_state' => dummy_request_params[:session_state],
            'scope' => "profile email"
          }
        )
      end
    end
  end

  private

  def dummy_request_params
    {
      code: '8c964a59-288b-4189-a43e-4c128f7a40c5.07f3451d-0331-4e26-9e3c-994011f1a431.94e82291-2a65-4643-9809-a3494a97b43f',
      session_state: 'e4567259-6c07-4dd1-800b-d01692ed2634',
      redirect_uri: 'http://example.com/oauth2'
    }
  end
end
