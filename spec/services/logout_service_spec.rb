require 'rails_helper'
require 'support/helpers/keycloak_responses'

RSpec.describe KeycloakOauth::LogoutService do
  include Helpers::KeycloakResponses

  describe '#logout' do
    subject { KeycloakOauth::LogoutService.new(access_token: access_token) }

    context 'when the access token is invalid' do
      let(:access_token) { 'some_token' }

      it 'raises an error' do
        stub_request(:post, 'http://domain/auth/realms/first_realm/protocol/openid-connect/logout').
          to_return(status: [401], body: keycloak_invalid_token_request_error_body)

        expect { subject.logout }.to raise_error(KeycloakOauth::AuthorizableError)
      end
    end
  end
end