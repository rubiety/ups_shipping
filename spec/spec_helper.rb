require "rubygems"
require "rspec"
require "rails"
require "active_record"
require "active_support"

require File.dirname(__FILE__) + '/../init'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
end
