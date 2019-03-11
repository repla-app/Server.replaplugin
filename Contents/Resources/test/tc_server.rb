#!/usr/bin/env ruby

# Test server
class TestServer < Minitest::Test
  def test_server
    command = "#{Shellwords.escape(SEARCH_FILE)} \"#{test_search_term}\""\
      " #{Shellwords.escape(test_data_directory)}"
    `#{command}`
  end
end
