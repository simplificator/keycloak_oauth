require 'rails_helper'

RSpec.describe KeycloakOauth::AuthenticationService do
  describe '#authenticate' do
    context 'when the authorization code can be exchanged for an access token' do
      it 'retrieves authentication information and stores it in session' do
        stub_request(:post, 'http://domain/auth/realms/first_realm/protocol/openid-connect/token').
          to_return(body: keycloak_tokens_request_body)

        existing_session = OpenStruct.new(existing_session_param: 'some_param')
        service = KeycloakOauth::AuthenticationService.new(
          authentication_params: dummy_authentication_params,
          session: existing_session
        )
        service.authenticate

        expect(service.session.access_token).to eq(dummy_access_token)
        expect(service.session.refresh_token).to eq(dummy_refresh_token)
      end
    end

    context 'when the authorization code is invalid/has expired' do
      it 'raises an error' do
        stub_request(:post, 'http://domain/auth/realms/first_realm/protocol/openid-connect/token').
          to_return(status: [400], body: keycloak_invalid_code_request_error_body)

        service = KeycloakOauth::AuthenticationService.new(
          authentication_params: dummy_authentication_params,
          session: OpenStruct.new
        )

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

  def keycloak_tokens_request_body
    "{\"access_token\":\"#{dummy_access_token}\"," \
    "\"expires_in\":32765,\"refresh_expires_in\":1800,\"refresh_token\":\"" \
    "#{dummy_refresh_token}\",\"token_type\":\"bearer\",\"not-before-policy\":0," \
    "\"session_state\":\"e4567259-6c07-4dd1-800b-d01692ed2634\",\"scope\":\"" \
    "profile email\"}"
  end

  def dummy_access_token
    "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJNMjhQwMTY5MmVkMjYzNCIsIm" \
    "FjciI6IjAiLCJhbGxvd2VkLW9yaWdpbnMiOlsiIl0sInJlYWxtX2FjYZXNvdXJjZV9hY2Nlc3Mi" \
    "Onsid2ViZ2F0ZSI6eyJyb2xlcyI6WyJzdXBlcmFkbWluIl19LCJY"
  end

  def dummy_refresh_token
    "eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJhNDk0NzcxOS01NWU5LTQzYTg" \
    "tYTU0NS1kOWQzMzAzNjEzMWEifQ.eyJqdGkiOiJmNGFkODcyZC1mZTRlLTQ1ZGMtOWFjOC0yODg1OW"
  end

  def keycloak_invalid_code_request_error_body
    "{\"error\":\"invalid_grant\",\"error_description\":\"Code not valid\"}"
  end
end
