require 'rails_helper'
require 'support/helpers/keycloak_responses'

RSpec.describe KeycloakOauth::AuthenticationService do
  include Helpers::KeycloakResponses

  describe '#authenticate' do
    subject do
      KeycloakOauth::AuthenticationService.new(
        authentication_params: dummy_authentication_params,
        session: session
      )
    end

    context 'when the authorization code can be exchanged for an access token' do
      let(:session) { OpenStruct.new(existing_session_param: 'some_param') }

      it 'retrieves authentication information and stores it in session' do
        stub_request(:post, 'http://domain/auth/realms/first_realm/protocol/openid-connect/token').
          to_return(body: keycloak_tokens_request_body)

        service = subject
        service.authenticate

        expect(service.session.access_token).to eq(access_token)
        expect(service.session.refresh_token).to eq(refresh_token)
      end
    end

    context 'when the authorization code is invalid/has expired' do
      let(:session) { OpenStruct.new }

      it 'raises an error' do
        stub_request(:post, 'http://domain/auth/realms/first_realm/protocol/openid-connect/token').
          to_return(status: [400], body: keycloak_invalid_code_request_error_body)

        expect { subject.authenticate }.to raise_error(KeycloakOauth::AuthenticationError)
      end
    end
  end

  private

  def dummy_authentication_params
    {
      code: '8c964a59-288b-4189-a43e-4c128f7a40c5.07f3451d-0331-4e26-9e3c-994011f1a431.94e82291-2a65-4643-9809-a3494a97b43f',
      session_state: '07f3451d-0331-4e26-9e3c-994011f1a431'
    }
  end
end
