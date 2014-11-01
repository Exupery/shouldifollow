ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  if File.exist?(".env")
    File.open(".env", "r").each_line do |line|
    	key = ""
    	value = ""
    	on_key = true
    	line.split("=").map.each { |token|
    	  if on_key
    	  	key = token
    	  else
    	  	value = token.gsub(/"/, "").chomp
    	  end
    	  on_key = false
    	}
    	ENV[key] = value if key != "RAILS_ENV"
    end
  end
end
