require 'rails_helper'
require 'support/helpers/keycloak_responses'

RSpec.describe KeycloakOauth::CallbacksController, type: :controller do
  include Helpers::KeycloakResponses

  routes { KeycloakOauth::Engine.routes }

  describe "GET oauth2" do
    subject { get :oauth2 }

    context 'when the host app overwrites after_sign_in_path' do
      it 'maps user and redirects to the specified path' do
        stub_request(:post, 'http://domain/auth/realms/first_realm/protocol/openid-connect/token').
          to_return(body: keycloak_authorization_code_body)
        stub_request(:get, 'http://domain/auth/realms/first_realm/protocol/openid-connect/userinfo').
          to_return(body: keycloak_user_info_request_body)

        expect(subject).to redirect_to('/second_page')
        expect(session['access_token']).to eq(access_token)
        expect(session['refresh_token']).to eq(refresh_token)
        expect(session['user_email_address']).to eq('first_user@example.com')
      end
    end

    context 'when the host app does not overwrite after_sign_in_path' do
      it 'redirects to root path' do
        stub_request(:post, 'http://domain/auth/realms/first_realm/protocol/openid-connect/token').
          to_return(body: keycloak_authorization_code_body)
        stub_request(:get, 'http://domain/auth/realms/first_realm/protocol/openid-connect/userinfo').
          to_return(body: keycloak_user_info_request_body)

        allow(described_class).to receive(:method_defined?).with(:after_sign_in_path).and_return(false)
        allow(described_class).to receive(:method_defined?).with(:map_authenticatable).and_return(true)

        expect(subject).to redirect_to('/')
      end
    end
  end
end
