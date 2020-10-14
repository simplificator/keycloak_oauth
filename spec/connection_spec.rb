require 'spec_helper'

RSpec.describe KeycloakOauth::Connection do
  let(:auth_url) { 'http://domain/auth' }
  let(:realm) { 'first_realm' }
  let(:client_id) { 'a_client' }
  let(:client_secret) { 'a_secret' }

  before do
    KeycloakOauth.configure do |config|
      config.auth_url = auth_url
      config.realm = realm
      config.client_id = client_id
      config.client_secret = client_secret
    end
  end

  describe '#authorization_endpoint' do
    subject { KeycloakOauth.connection }

    it 'returns scoped authorization_endpoint' do
      expect(subject.authorization_endpoint).to eq('http://domain/auth/realms/first_realm/protocol/openid-connect/auth?client_id=a_client&response_type=code')
    end

    context 'when response_type is passed in' do
      it 'returns scoped authorization_endpoint with custom response_type' do
        endpoint = subject.authorization_endpoint(options: { response_type: 'token' })

        expect(endpoint).to eq('http://domain/auth/realms/first_realm/protocol/openid-connect/auth?client_id=a_client&response_type=token')
      end
    end
  end
end
