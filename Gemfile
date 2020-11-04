source "https://rubygems.org"

gemspec

group :test do
  gem 'webmock'
end

group :development, :test do
  # Needed for the dummy app.
  gem 'activerecord-session_store'
  gem 'uglifier', '>= 1.3.0'
  gem 'turbolinks', '~> 5'
end
