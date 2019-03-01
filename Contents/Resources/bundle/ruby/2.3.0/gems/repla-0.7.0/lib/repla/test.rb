module Repla
  # Test
  module Test
    # General
    TEST_PAUSE_TIME = 2.00

    # Ruby
    REPLA_FILE = File.join(File.dirname(__FILE__), '../repla')
    TEST_DIRECTORY = File.join(File.dirname(__FILE__), 'test')
    LIB_DIRECTORY = File.join(TEST_DIRECTORY, 'lib')
    HELPER_FILE = File.join(LIB_DIRECTORY, 'helper')
    VIEW_HELPER_FILE = File.join(LIB_DIRECTORY, 'view_helper')

    # Test Assets
    def self.html_file(filename)
      File.join(TEST_HTML_DIRECTORY, filename)
    end

    def self.html_server_url(filename)
      'http://127.0.0.1:5000/' + filename
    end

    # HTML
    TEST_HTML_DIRECTORY = File.join(TEST_DIRECTORY, 'html')
    INDEX_HTML_FILENAME = 'index.html'.freeze
    INDEXJQUERY_HTML_FILENAME = 'indexjquery.html'.freeze
    INDEX_HTML_FILE = html_file(INDEX_HTML_FILENAME)
    INDEXJQUERY_HTML_FILE = html_file(INDEXJQUERY_HTML_FILENAME)
    INDEX_HTML_TITLE = 'Index'.freeze
    INDEXJQUERY_HTML_TITLE = 'Index JQuery'.freeze

    # JavaScript
    TEST_ASSETS_JAVASCRIPT_DIRECTORY = File.join(TEST_DIRECTORY, 'js')
    TITLE_JAVASCRIPT_FILE = File.join(TEST_ASSETS_JAVASCRIPT_DIRECTORY,
                                      'title.js')
    # Plugins
    TEST_PLUGIN_DIRECTORY = File.join(TEST_DIRECTORY, 'bundles')
    HELLOWORLD_PLUGIN_FILE = File.join(TEST_PLUGIN_DIRECTORY,
                                       'HelloWorld.replabundle')
    HELLOWORLD_PLUGIN_NAME = 'HelloWorld'.freeze
    TEST_SERVER_PLUGIN_NAME = 'TestServer'.freeze
    TEST_SERVER_PLUGIN_FILE = File.join(TEST_PLUGIN_DIRECTORY,
                                        'TestServer.replabundle')
    INDEX_HTML_URL = html_server_url(INDEX_HTML_FILENAME)
    INDEXJQUERY_HTML_URL = html_server_url(
      INDEXJQUERY_HTML_FILENAME
    )
    NO_SERVER_URL = 'NoServer'.freeze
    PRINT_PLUGIN_FILE = File.join(TEST_PLUGIN_DIRECTORY, 'Print.replabundle')
    PRINT_PLUGIN_NAME = 'Print'.freeze
    TESTLOG_PLUGIN_FILE = File.join(TEST_PLUGIN_DIRECTORY,
                                    'TestLog.replabundle')
    TESTLOG_PLUGIN_NAME = 'TestLog'.freeze
    INVALID_PLUGIN_FILE = File.join(TEST_PLUGIN_DIRECTORY,
                                    'Invalid.replabundle')
    INVALID_PLUGIN_NAME = 'Invalid'.freeze

    # Local Asssets

    # JavaScript
    TEST_JAVASCRIPT_DIRECTORY = File.join(LIB_DIRECTORY, '../js')
    LASTCODE_JAVASCRIPT_FILE = File.join(TEST_JAVASCRIPT_DIRECTORY,
                                         'lastcode.js')
    FIRSTCODE_JAVASCRIPT_FILE = File.join(TEST_JAVASCRIPT_DIRECTORY,
                                          'firstcode.js')
    NODOM_JAVASCRIPT_FILE = File.join(TEST_JAVASCRIPT_DIRECTORY, 'nodom.js')
    TEXT_JAVASCRIPT_FILE = File.join(TEST_JAVASCRIPT_DIRECTORY, 'text.js')
    TEXTJQUERY_JAVASCRIPT_FILE = File.join(TEST_JAVASCRIPT_DIRECTORY,
                                           'textjquery.js')
  end
end
