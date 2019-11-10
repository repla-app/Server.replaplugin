#!/usr/bin/env ruby

require 'minitest/autorun'

require_relative '../lib/repla/lib/escape.rb'

# Test escape
class TestEscape < Minitest::Test
  using Escape
  def test_shell_escape_path
    string = '/../../applescript/exists.scpt'
    result = string.shell_escape
    test_result = '/../../applescript/exists.scpt'
    assert_equal(test_result, result)
  end

  def test_shell_escape_string
    string = 'This is a test string
'
    result = string.shell_escape
    test_result = 'This\ is\ a\ test\ string\'
\''
    assert_equal(test_result, result)
  end

  def test_shell_escape_code
    string = 'var codeTags = document.getElementsByTagName(\'code\');
var lastCodeTag = codeTags[codeTags.length - 1];
lastCodeTag.innerHTML;'
    result = string.shell_escape
    test_result = 'var\ codeTags\ \=\ document.'\
'getElementsByTagName\(\\\'code\\\'\)\;\'
\'var\ lastCodeTag\ \=\ codeTags\[codeTags.length\ -\ 1\]\;\'
\'lastCodeTag.innerHTML\;'
    assert_equal(test_result, result)
  end

  def test_javascript_argument_word
    string = 'one'
    result = string.javascript_argument
    test_result = '\'one\''
    assert_equal(test_result, result)
  end

  def test_javascript_argument_words
    string = '1 2 3'
    result = string.javascript_argument
    test_result = '\'1 2 3\''
    assert_equal(test_result, result)
  end

  def test_javascript_argument_punctuation
    string = 'irb(main):001:0> 1 + 1'
    result = string.javascript_argument
    test_result = '\'irb(main):001:0> 1 + 1\''
    assert_equal(test_result, result)
  end

  def test_javascript_argument_html
    string = 'Using <a href="http://brew.sh/">Homebrew</a>, <code>brew '\
      'install asdf</code>'
    result = string.javascript_argument
    test_result = '\'Using <a href="http://brew.sh/">Homebrew</a>, <code>brew '\
      'install asdf</code>\''
    assert_equal(test_result, result)
  end

  def test_javascript_escape_slashes
    string = '    eiusmod self.gsub("\'", "\\\\\\\\\'")'
    string.javascript_escape!
    test_result = '    eiusmod self.gsub("\\\'", "\\\\\\\\\\\\\\\\\\\'")'
    assert_equal(test_result, string)
  end

  def test_javascript_escape_quote
    string = 'WCSEARCH_FILE = File.join(__dir__, '\
      '"..", \'eiusmod.rb\')'
    string.javascript_escape!
    test_result = 'WCSEARCH_FILE = File.join(__dir__, '\
      '"..", \\\'eiusmod.rb\\\')'
    assert_equal(test_result, string)
  end

  def test_javascript_escape_html
    file = File.open('html/index.html')
    string = file.read
    result = string.javascript_argument
    test_result = '\'<!DOCTYPE html>\n<html lang="en">\n<head>\n  <meta '\
      'charset="utf-8">\n  <title>Test</title>\n  <link rel="stylesheet" '\
      'href="../../lib/repla/resources/css/raster.css">\n  <script '\
      'type="text/javascript" src=\n  "../../lib/repla/resources/js/zepto.js">'\
      '</script>\n  <script type="text/javascript" '\
      'src="js/test.js"></script>\n</head>\n<body>\n  <header '\
      'role="banner">\n    <h1>1Percenter</h1>\n    <nav>\n      '\
      '<ul>\n        <li>\n          <a href="#">About</a>\n        '\
      '</li>\n      </ul>\n    </nav>\n  </header>\n  <section>\n    '\
      '<header>\n      <h1>Content</h1>\n    </header>\n    <p id="text">'\
      'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed\n    do '\
      'eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim '\
      'ad\n    minim veniam, quis nostrud exercitation ullamco laboris nisi '\
      'ut aliquip ex\n    ea commodo consequat. Duis aute irure dolor in '\
      'reprehenderit in voluptate\n    velit esse cillum dolore eu fugiat '\
      'nulla pariatur. Excepteur sint occaecat\n    cupidatat non proident, '\
      'sunt in culpa qui officia deserunt mollit anim id\n    est '\
      'laborum.</p>\n  </section>\n  <footer>\n    ©2013 Roben Kleene\n  '\
      '</footer><!-- 1P -->\n</body>\n</html>\n\''
    assert_equal(test_result, result)
  end
end
