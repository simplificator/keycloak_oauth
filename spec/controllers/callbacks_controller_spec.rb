require 'rails_helper'

RSpec.describe KeycloakOauth::CallbacksController, type: :controller do
  routes { KeycloakOauth::Engine.routes }

  describe "GET openid_connect" do
   context 'when the host app overwrites after_sign_in_path' do
     it 'redirects to the specified path' do
       get :openid_connect

       expect(subject).to redirect_to('/second_page')
     end
   end

   context 'when the host app does not overwrite after_sign_in_path' do
     subject { get :openid_connect }

     it 'redirects to root path' do
       allow(described_class).to receive(:method_defined?).with(:after_sign_in_path).and_return(false)
       get :openid_connect

       expect(subject).to redirect_to('/')
     end
   end
  end
end
