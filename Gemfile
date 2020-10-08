source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
gem 'image_processing', '~> 1.2'
gem 'mini_magick', '~> 4.10', '>= 4.10.1'
gem 'aws-sdk-s3', '~> 1.83', require: false

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Implement state machines
gem 'aasm', '~> 5.0', '>= 5.0.8'

# Add permalinks using slugs
gem 'friendly_id', '~> 5.3'

# Flexible authentication solution for Rails with Warden
gem 'devise', '~> 4.7', '>= 4.7.2'

# Object oriented authorization for Rails applications
gem 'pundit', '~> 2.1'

# Pagination
gem 'pagy', '~> 3.8', '>= 3.8.3'

# For Action Mailer and background jobs
gem 'sidekiq', '~> 6.1', '>= 6.1.2'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem 'rubocop', '~> 0.85.1', require: false
  gem 'rubocop-rails', '~> 2.6'
  gem 'rubocop-minitest', '~> 0.9.0'
  gem 'bullet', '~> 6.1'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'brakeman', '~> 4.9', '>= 4.9.1'

  gem 'capistrano', '~> 3.14', '>= 3.14.1', require: false
  gem 'capistrano-bundler', '~> 2.0', '>= 2.0.1', require: false
  gem 'capistrano-rails', '~> 1.6', '>= 1.6.1', require: false
  gem 'capistrano-rbenv', '~> 2.2', require: false
  gem 'capistrano3-puma', '~> 4.0', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
