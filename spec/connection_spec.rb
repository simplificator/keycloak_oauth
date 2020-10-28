require 'rails_helper'
require 'support/helpers/keycloak_responses'

RSpec.describe KeycloakOauth::Connection do
  include Helpers::KeycloakResponses

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

  describe '#get_user_information' do
    subject do
      KeycloakOauth.connection.get_user_information(
        access_token: 'access_token',
        refresh_token: 'refresh_token'
      )
    end

    it 'retrieves user information' do
      stub_request(:get, 'http://domain/auth/realms/first_realm/protocol/openid-connect/userinfo').
        to_return(body: keycloak_user_info_request_body)

      expect(subject).to eq({
        "sub" => '62647491-07ba-4961-8b9a-38e43916b4a0',
        "email_verified" => true,
        "name" => 'First User',
        "groups" => ['/group_A'],
        "preferred_username" => 'first_user',
        "given_name" => 'First',
        "family_name" => 'User',
        "email" => 'first_user@example.com'
        }
      )
    end
  end
end
