require 'rails_helper'

RSpec.describe KeycloakOauth do
  it "has a version number" do
    expect(KeycloakOauth::VERSION).not_to be nil
  end

  context 'when configuration is provided' do
    let(:auth_url) { 'http://domain/auth' }
    let(:realm) { 'first_realm' }
    let(:client_id) { 'a_client' }
    let(:client_secret) { 'a_secret' }

    subject { KeycloakOauth.connection }

    it 'initializes a connection' do
      expect(subject.auth_url).to eq('http://domain/auth')
      expect(subject.realm).to eq('first_realm')
      expect(subject.client_id).to eq('a_client')
      expect(subject.client_secret).to eq('a_secret')
      expect(subject.callback_module.to_s).to eq('KeycloakOauthCallbacks')
    end
  end
end
