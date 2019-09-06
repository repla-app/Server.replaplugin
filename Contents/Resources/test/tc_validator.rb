#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby

require 'minitest/autorun'
require_relative 'lib/test_setup'
require_relative '../lib/config'
require_relative '../lib/validator'

# Test server
class TestServer < Minitest::Test
  def test_validator
    assert_nil(Repla::Server::Validator.validate(nil))
    config = Repla::Server::Config.new(TEST_DELAY_OPTIONS_LONG)
    assert_nil(Repla::Server::Validator.validate(config))
    config = Repla::Server::Config.new(TEST_DELAY_OPTIONS_LONG)
  end
end

