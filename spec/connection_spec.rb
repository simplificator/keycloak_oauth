require 'rails_helper'

RSpec.describe KeycloakOauth::Connection do
  let(:auth_url) { 'http://domain/auth' }
  let(:realm) { 'first_realm' }
  let(:client_id) { 'a_client' }
  let(:client_secret) { 'a_secret' }

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

  describe '#authentication_endpoint' do
    subject { KeycloakOauth.connection }

    it 'returns scoped authorization_endpoint' do
      expect(subject.authentication_endpoint).to eq('http://domain/auth/realms/first_realm/protocol/openid-connect/token')
    end
  end
end
