require 'rails_helper'
require 'support/helpers/keycloak_responses'

RSpec.describe KeycloakOauth::LogoutService do
  include Helpers::KeycloakResponses

  let(:service) { KeycloakOauth::LogoutService.new(session) }

  describe '#perform' do
    let(:session) { OpenStruct.new(access_token: 'token_A', refresh_token: 'token_B') }

    subject { service.perform }

    it 'logs out from Keycloak' do
      stub_request(:post, 'http://domain/auth/realms/first_realm/protocol/openid-connect/logout').
        to_return(status: [204], body: nil) # Keycloak replies with an empty body.

      subject

      expect(service.http_response.code_type).to eq(Net::HTTPNoContent)
      expect(service.parsed_response_body).to be_nil
    end

    context 'when the access token is invalid' do
      let(:session) { OpenStruct.new(access_token: 'invalid') }

      it 'raises an error' do
        stub_request(:post, 'http://domain/auth/realms/first_realm/protocol/openid-connect/logout').
          to_return(status: [401], body: keycloak_invalid_token_request_error_body)

        expect { subject }.to raise_error(KeycloakOauth::AuthorizableError)
      end
    end
  end
end
