require 'rails_helper'
require 'support/helpers/keycloak_responses'

RSpec.describe KeycloakOauth::UserInfoRetrievalService do
  include Helpers::KeycloakResponses

  let(:service) do
    KeycloakOauth::UserInfoRetrievalService.new(
      access_token: access_token, refresh_token: refresh_token
    )
  end

  describe '#perform' do
    subject { service.perform }

    context 'when the user information can be retrieved from Keycloak' do
      it 'retrieves authentication information and stores it in session' do
        stub_request(:get, 'http://domain/auth/realms/first_realm/protocol/openid-connect/userinfo').
          to_return(body: keycloak_user_info_request_body)

        subject

        expect(service.http_response.code_type).to eq(Net::HTTPOK)
        expect(service.parsed_response_body).to eq({
          "sub" => '62647491-07ba-4961-8b9a-38e43916b4a0',
          "email_verified" => true,
          "name" => 'First User',
          "groups" => ['/group_A'],
          "preferred_username" => 'first_user',
          "given_name" => 'First',
          "family_name" => 'User',
          "email" => 'first_user@example.com'
          }
        )
      end
    end

    context 'when the access token is invalid' do
      let(:access_token) { 'some_token' }

      it 'raises an error' do
        stub_request(:get, 'http://domain/auth/realms/first_realm/protocol/openid-connect/userinfo').
          to_return(status: [401], body: keycloak_invalid_token_request_error_body)

        expect { subject }.to raise_error(KeycloakOauth::AuthorizableError)
      end
    end
  end
end
