require_relative 'lib/keycloak_oauth/version'

Gem::Specification.new do |spec|
  spec.name          = "keycloak_oauth"
  spec.version       = KeycloakOauth::VERSION
  spec.authors       = ["simplificator"]
  spec.email         = ["dev@simplificator.com"]

  spec.summary       = %q{Implementing OAuth with Keycloak in Ruby}
  spec.homepage      = "https://rubygems.org/gems/keycloak_oauth"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/simplificator/keycloak_oauth"
  spec.metadata["changelog_uri"] = "https://github.com/simplificator/keycloak_oauth"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", "~> 6.0.3", ">= 6.0.3.2"
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'sqlite3'
end
