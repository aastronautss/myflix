source 'https://rubygems.org'
ruby '2.1.2'

gem 'bootstrap-sass', '3.1.1.1'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'bcrypt'
gem 'sidekiq'
gem 'carrierwave'
gem 'mini_magick'
gem 'carrierwave-aws'

gem 'bootstrap_form'
gem 'figaro'

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'letter_opener'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '3.5'
  gem 'fabrication'
  gem 'faker'
end

group :test do
  gem 'database_cleaner', '1.4.1'
  gem 'shoulda-matchers', '2.8.0'
  gem 'capybara'
  gem 'capybara-email'
  gem 'vcr', '2.9.3'
end

group :production, :staging do
  gem 'unicorn'
  gem 'rails_12factor'
end
