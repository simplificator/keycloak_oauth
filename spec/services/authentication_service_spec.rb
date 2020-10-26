require 'rails_helper'

RSpec.describe KeycloakOauth::AuthenticationService do
  describe '#authenticate' do
    context 'when the authorization code is invalid/has expired' do
      it 'raises an error' do
        stub_request(:post, 'http://domain/auth/realms/first_realm/protocol/openid-connect/token').
          to_return(status: [400], body: invalid_code_message)

        service = KeycloakOauth::AuthenticationService.new(dummy_authentication_params)

        expect { service.authenticate }.to raise_error(KeycloakOauth::AuthenticationError)
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

  def invalid_code_message
    "{\"error\":\"invalid_grant\",\"error_description\":\"Code not valid\"}"
  end
end
