require 'rails_helper'
require 'support/helpers/keycloak_responses'

RSpec.describe KeycloakOauth::CallbacksController, type: :controller do
  include Helpers::KeycloakResponses

  routes { KeycloakOauth::Engine.routes }

  describe "GET oauth2" do
   context 'when the host app overwrites after_sign_in_path' do
     it 'redirects to the specified path' do
       stub_request(:post, 'http://domain/auth/realms/first_realm/protocol/openid-connect/token').
         to_return(body: keycloak_tokens_request_body)

       get :oauth2

       expect(subject).to redirect_to('/second_page')
       expect(session['access_token']).to eq(access_token)
       expect(session['refresh_token']).to eq(refresh_token)
     end
   end

   context 'when the host app does not overwrite after_sign_in_path' do
     subject { get :oauth2 }

     it 'redirects to root path' do
       stub_request(:post, 'http://domain/auth/realms/first_realm/protocol/openid-connect/token').
        to_return(body: keycloak_tokens_request_body)

       allow(described_class).to receive(:method_defined?).with(:after_sign_in_path).and_return(false)
       get :oauth2

       expect(subject).to redirect_to('/')
     end
   end
  end
end
