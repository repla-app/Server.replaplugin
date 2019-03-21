#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby

require 'minitest/autorun'

require_relative 'lib/test_setup'
require 'repla'

# Test CLI
class TestCLI < Minitest::Test
  SYMLINK_DST = File.join(__dir__, 'repla')
  CLI_PATH_COMPONENT = 'Contents/Resources/Scripts/repla'.freeze
  PLUGIN_ROOT = File.join(__dir__, '../../../')
  def setup
    Repla.load_plugin(PLUGIN_ROOT)
    bundle_command = 'osascript -e \'POSIX path of '\
    '(path to application "Repla")\''
    app_bundle_path = `#{bundle_command}`
    app_bundle_path.chomp!
    symlink_src = File.join(app_bundle_path, CLI_PATH_COMPONENT)
    File.symlink(symlink_src, SYMLINK_DST)
  end

  def teardown
    File.delete(SYMLINK_DST)
  end

  def test_cli
    server_command = "#{SERVER_COMMAND_PATH} #{SERVER_ROOT}"
    command = "#{SYMLINK_DST} server "\
      "#{Shellwords.escape(server_command)}"
    # puts "command = #{command}"
    `#{command}`
    # Repla::Test.block_until do
    #   window_id = Repla::Test::Helper.window_id
    #   !window_id.nil?
    # end
  end
end
