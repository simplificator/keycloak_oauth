require 'rails_helper'
require 'support/helpers/keycloak_responses'

RSpec.describe KeycloakOauth::LogoutService do
  include Helpers::KeycloakResponses

  describe '#logout' do
    let(:session) { OpenStruct.new(access_token: 'token_A', refresh_token: 'token_B') }

    subject { KeycloakOauth::LogoutService.new(session) }

    it 'logs out from Keycloak' do
      stub_request(:post, 'http://domain/auth/realms/first_realm/protocol/openid-connect/logout').
        to_return(status: [204], body: nil) # Keycloak replies with an empty body.

      expect(subject.logout).to be_nil
    end

    context 'when the access token is invalid' do
      let(:session) { OpenStruct.new(access_token: 'invalid') }

      it 'raises an error' do
        stub_request(:post, 'http://domain/auth/realms/first_realm/protocol/openid-connect/logout').
          to_return(status: [401], body: keycloak_invalid_token_request_error_body)

        expect { subject.logout }.to raise_error(KeycloakOauth::AuthorizableError)
      end
    end
  end
end
