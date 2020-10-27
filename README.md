# KeycloakOauth

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/keycloak_oauth`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'keycloak_oauth'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install keycloak_oauth

## Usage

### Using `keycloak_oauth` in a Ruby on Rails app

The configuration must be defined in the app by initialising the relevant attributes within a configuration block. For example, you could add an initializer script called `keycloak_oauth.rb` holding the following code:

```ruby
KeycloakOauth.configure do |config|
  config.auth_url = 'TBA' # (you could reference a Rails credential here for example)
  config.realm = 'TBA'
  config.client_id = 'TBA'
  config.client_secret = 'TBA'
end
```

This then allows you to access the `KeycloakOauth` APIs:
`KeycloakOauth.connection.authorization_endpoint`

You can allow the user to log in with Keycloak by adding adding a link that points to `KeycloakOauth.connection.authorization_endpoint`:
e.g.
`<%= link_to 'Login with Keycloak', KeycloakOauth.connection.authorization_endpoint %>`

Once authentication is performed, the access and refresh tokens are stored in the session and can be used in your app as wished.

**Keycloak callback URL**
Keycloak needs a callback URL to send the authorization code to once a user logs in.
By default, once authentication is performed, we redirect to the `/` path (i.e. whatever the root path is set to in the host app).
If you need the user to be redirected to something other than the root path, you can achieve that in the following way:

1. Add a new module (could be a controller concern) e.g. `KeycloakOauthCallbacks`
2. In this module, define a method `after_sign_in_path`
3. In the method, perform whatever logic you need to return the right path e.g.
```ruby
def after_sign_in_path
  my_custom_path
end
```
4. Tell the gem where you've overridden the paths by setting the following config in your configuration initializer file:
```ruby
KeycloakOauth.configure do |config|
  ...
  config.callback_module = KeycloakOauthCallbacks
end
```

**User mapping**
The host app is responsible for mapping a Keycloak session with a Rails user session. This can be achieved
by implementing the `map_authenticatable` method in the module configured above (e.g. `KeycloakOauthCallbacks` in our example).
You can get the user information by making a call to `KeycloakOauth.connection.get_user_information` to which you pass in the access token.
See here an example of retrieving the user information and saving the email address in the Rails session:

```ruby
def map_authenticatable(_request)
  service = KeycloakOauth.connection.get_user_information(access_token: session[:access_token])
  session[:user_email_address] = service.user_information['email']
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/keycloak_oauth. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/keycloak_oauth/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the KeycloakOauth project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/keycloak_oauth/blob/master/CODE_OF_CONDUCT.md).
