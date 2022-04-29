require 'rails_helper'
require 'support/helpers/keycloak_responses'

RSpec.describe KeycloakOauth::RefreshAuthenticationService do
  include Helpers::KeycloakResponses

  describe '#perform' do
    subject do
      KeycloakOauth::RefreshAuthenticationService.new(
        session: session
      )
    end

    context 'when the refresh token can be exchanged for an access token' do
      let(:session) { OpenStruct.new(existing_session_param: 'some_param') }

      it 'retrieves authentication information and stores it in session' do
        stub_request(:post, 'http://domain/auth/realms/first_realm/protocol/openid-connect/token').
          to_return(body: keycloak_refresh_token_request_body)

        service = subject
        Timecop.freeze(Time.new(2022, 1, 1, 0, 0, 0, "+01:00")) do
          service.authenticate
        end

        expect(service.session.access_token).to eq(access_token)
        expect(service.session.refresh_token).to eq(refresh_token)

        expect(service.session.access_token_expires_at).to eq(Time.new(2022, 1, 1, 9, 6, 5, "+01:00"))
        expect(service.session.refresh_token_expires_at).to eq(Time.new(2022, 1, 1, 0, 30, 0, "+01:00"))
      end
    end

    context 'when the authorization code is invalid/has expired' do
      let(:session) { OpenStruct.new }

      it 'raises an error' do
        stub_request(:post, 'http://domain/auth/realms/first_realm/protocol/openid-connect/token').
          to_return(status: [400], body: keycloak_invalid_refresh_token_error_body)

        expect { subject.authenticate }.to raise_error(KeycloakOauth::AuthorizableError)
      end
    end
  end
end
