require 'rails_helper'
require 'capybara/poltergeist'

RSpec.configure do |config|
  config.include FeatureMacros, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) { DatabaseCleaner.clean_with(:truncation) }
  config.before(:each) { DatabaseCleaner.strategy = :transaction }
  config.before(:each, js: true) { DatabaseCleaner.strategy = :truncation }
  config.before(:each) { DatabaseCleaner.start }
  config.after(:each) { DatabaseCleaner.clean }

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(
      app,
      timeout: 90, js_errors: true,
      phantomjs_logger: Logger.new(STDOUT), window_size: [1020, 1024]
    )
  end

  Capybara.javascript_driver = :poltergeist
  # Capybara.ignore_hidden_elements = false
  # Capybara.default_max_wait_time = 5
end

def with_hidden_fields
  Capybara.ignore_hidden_elements = false
  yield
  Capybara.ignore_hidden_elements = true
end
