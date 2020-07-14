ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/autorun'
require_relative './remove_uploaded_files'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def attach_file_to_record(record)
    record.attach(
      io: File.open(Rails.root.to_s + '/test/fixtures/files/square.png'),
      filename: 'square.png'
    )
  end

  def devise_token_generator(klass, token)
    yield Devise.token_generator.generate(klass, token)
  end
end
