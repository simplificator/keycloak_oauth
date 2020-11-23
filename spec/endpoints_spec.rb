require 'rails_helper'

RSpec.describe KeycloakOauth::Endpoints do
  let(:auth_url) { 'http://domain/auth' }
  let(:realm) { 'first_realm' }
  let(:client_id) { 'a_client' }
  let(:client_secret) { 'a_secret' }

  subject { KeycloakOauth.connection }

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

    context 'when redirect_uri is passed in' do
      it 'returns scoped authorization_endpoint with custom redirect_uri' do
        endpoint = subject.authorization_endpoint(options: { redirect_uri: 'http://example.com/oauth2' })

        expect(endpoint).to eq('http://domain/auth/realms/first_realm/protocol/openid-connect/auth?client_id=a_client&response_type=code&redirect_uri=http://example.com/oauth2')
      end
    end
  end

  describe '#authentication_endpoint' do
    subject { KeycloakOauth.connection }

    it 'returns scoped authorization_endpoint' do
      expect(subject.authentication_endpoint).to eq('http://domain/auth/realms/first_realm/protocol/openid-connect/token')
    end
  end

  describe '#user_info_endpoint' do
    subject { KeycloakOauth.connection }

    it 'returns scoped user_info_endpoint' do
      expect(subject.user_info_endpoint).to eq('http://domain/auth/realms/first_realm/protocol/openid-connect/userinfo')
    end
  end

  describe '#logout_endpoint' do
    it 'returns scoped logout_endpoint' do
      expect(subject.logout_endpoint).to eq('http://domain/auth/realms/first_realm/protocol/openid-connect/logout')
    end
  end

  describe '#users_endpoint' do
    it 'returns scoped users_endpoint' do
      expect(subject.users_endpoint).to eq('http://domain/auth/admin/realms/first_realm/users')
    end
  end

  describe '#put_execute_actions_email_endpoint' do
    let(:user_id) { 'abcdefgh' }

    it 'returns scoped put_execute_actions_email_endpoint' do
      expect(subject.put_execute_actions_email_endpoint(user_id))
        .to eq('http://domain/auth/admin/realms/first_realm/users/abcdefgh/execute-actions-email')
    end
  end
end
