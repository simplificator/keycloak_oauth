require 'rails_helper'
require 'support/helpers/keycloak_responses'

RSpec.describe KeycloakOauth::Connection do
  include Helpers::KeycloakResponses

  let(:auth_url) { 'http://domain/auth' }
  let(:realm) { 'first_realm' }
  let(:client_id) { 'a_client' }
  let(:client_secret) { 'a_secret' }

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

  describe '#logout' do
    subject do
      KeycloakOauth.connection.logout(
        access_token: 'access_token',
        refresh_token: 'refresh_token'
      )
    end

    it 'logs out' do
      stub_request(:post, 'http://domain/auth/realms/first_realm/protocol/openid-connect/logout').
        to_return(status: [204], body: nil)

      expect(subject).to be_nil
    end
  end
end
