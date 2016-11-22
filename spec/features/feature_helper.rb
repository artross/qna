require 'rails_helper'
require 'capybara/poltergeist'

RSpec.configure do |config|
  config.include FeatureHelpers, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) { DatabaseCleaner.clean_with(:truncation) }
  config.before(:each) { DatabaseCleaner.strategy = :transaction }
  config.before(:each, js: true) { DatabaseCleaner.strategy = :truncation }
  config.before(:each) { DatabaseCleaner.start }
  config.after(:each) { DatabaseCleaner.clean }

  Capybara.javascript_driver = :poltergeist
end
