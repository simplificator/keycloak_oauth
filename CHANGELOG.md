# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.1] - 2022-06-16

### Changed

- Extracted `KeycloakOauth::NotFoundError` and `KeycloakOauth::AuthorizableError` into separate file. When using Zeitwerk code loader in your main application, it was sometimes unable to find these classes.

## [2.0.0] - 2022-06-14

### Breaking

- To avoid confusion what kind of token will be requested from Keycloak, we renamed `KeycloakOauth::PostTokenService` to `KeycloakOauth::PostAuthorizationCodeService`.
- Rails' `default_url_options` are required to be configured.

### Added

- New service named `KeycloakOauth::PostRefreshTokenService` to request a new access token with a refresh token.
- Expiration of both the refresh and access token will be written to the session. You can retrieve them by calling `session[:access_token_expires_at]` or `session[:refresh_token_expires_at]` in your controller.

### Changed

- The default redirection url for a successful login has been changed from `/` to the `root_path` of your app.

## [1.1.0] - 2022-04-13

### Added

- Support for Rails 6.1, 7.0 and Ruby 3.1

## [1.0.0] - 2021-07-09

### Breaking

- Removed support for Ruby < 2.6

### Added

- Testing for Ruby 3.0

### Changed

- Updated `rails` and `activerecord_session_store` for dummy app
