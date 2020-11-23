require 'rails_helper'
require 'support/helpers/keycloak_responses'

RSpec.describe KeycloakOauth::PutExecuteActionsEmailService do
  include Helpers::KeycloakResponses

  let(:service) do
    KeycloakOauth::PutExecuteActionsEmailService.new(
      connection: KeycloakOauth.connection,
      access_token: 'access_token',
      refresh_token: 'refresh_token',
      user_id: 'existing-user-id',
      actions: actions
    )
  end
  let(:actions) { ['UPDATE_PASSWORD', 'VERIFY_EMAIL'] }

  describe '#perform' do
    subject { service.perform }

    context 'when the actions were successfully enabled in Keycloak' do
      it 'performs request' do
        stub_request(:put, 'http://domain/auth/admin/realms/first_realm/users/existing-user-id/execute-actions-email')
          .with(body: dummy_actions_as_json)
          .to_return(status: [200], body: "") # Keycloak replies with an empty body.

        subject

        expect(service.http_response.code_type).to eq(Net::HTTPOK)
        expect(service.parsed_response_body).to be_empty
      end
    end

    context 'when Keycloak returned an error' do
      context 'when a user with the given ID cannot be found in Keycloak' do
        it 'raises a NotFound error' do
          stub_request(:put, 'http://domain/auth/admin/realms/first_realm/users/existing-user-id/execute-actions-email')
            .with(body: dummy_actions_as_json)
            .to_return(status: [404], body: keycloak_user_not_found_error_body)

          expect { subject }.to raise_error(KeycloakOauth::NotFoundError)
        end
      end

      context 'when the access token has expired' do
        it 'raises an AuthorizableError' do
          stub_request(:put, 'http://domain/auth/admin/realms/first_realm/users/existing-user-id/execute-actions-email')
            .with(body: dummy_actions_as_json)
            .to_return(status: [401], body: keycloak_invalid_token_request_error_body)

          expect { subject }.to raise_error(KeycloakOauth::AuthorizableError)
        end
      end
    end
  end

  private

  def dummy_actions_as_json
    "[\"UPDATE_PASSWORD\",\"VERIFY_EMAIL\"]"
  end

  def keycloak_user_not_found_error_body
    "{\"error\":\"User not found\"}"
  end
end
