source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "3.2.2"

gem "active_model_serializers"
gem "active_storage_validations", "0.9.8"
gem "bcrypt", "3.1.18"
gem "bootsnap", require: false
gem "cancancan"
gem "chartkick"
gem "config"
gem "devise", "~> 4.1"
gem "elasticsearch-model"
gem "elasticsearch-rails"
gem "groupdate"
gem "importmap-rails"
gem "jbuilder"
gem "jwt"
gem "money-rails"
gem "mysql2"
gem "omniauth"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"
gem "pagy"
gem "pry-rails"
gem "puma", "~> 5.0"
gem "rack-cors"
gem "rails", "~> 7.0.5"
gem "rails-i18n"
gem "ransack"
gem "simplecov"
gem "sprockets-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i(mingw mswin x64_mingw jruby)

group :development, :test do
  gem "debug", platforms: %i(mri mingw x64_mingw)
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "rails-controller-testing"
  gem "rubocop", "~> 1.26", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.14.0", require: false
  gem "shoulda-matchers", "~> 5.0"

  gem "rspec-rails", "~> 7.0.0"

  gem "faker"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
