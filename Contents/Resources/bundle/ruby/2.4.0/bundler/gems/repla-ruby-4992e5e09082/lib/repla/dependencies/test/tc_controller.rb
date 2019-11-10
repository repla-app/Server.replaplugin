#!/usr/bin/env ruby

require 'minitest/autorun'

require_relative 'lib/test_setup'

require_relative 'lib/test_javascript_helper'

require_relative '../lib/controller'

# Test controller
class TestController < Minitest::Test
  def setup
    @controller = Repla::Dependencies::Controller.new
  end

  def teardown
    @controller.view.close
  end

  def test_missing_dependency
    dependency = Repla::Dependencies::Dependency.new('asdf', :shell_command)

    @controller.missing_dependency(dependency)

    javascript_helper = Repla::Dependencies::Tests::JavaScriptHelper
    test_result_name = javascript_helper.last_name(@controller.view)
    assert(!test_result_name.empty?)
    assert_equal(test_result_name, dependency.name)

    test_type_string = @controller.class.send(:string_for_type, dependency.type)
    test_result_type = javascript_helper.last_type(@controller.view)
    assert(!test_result_type.empty?)
    assert_equal(test_result_type, test_type_string)
  end

  def test_missing_with_installation_instructions
    test_installation = 'Using <a href="http://brew.sh/">Homebrew</a>,'\
      ' <code>brew install asdf</code>'
    dependency = Repla::Dependencies::Dependency.new(
      'asdf', :shell_command, installation_instructions: test_installation
    )

    @controller.missing_dependency(dependency)

    javascript_helper = Repla::Dependencies::Tests::JavaScriptHelper
    test_result_name = javascript_helper.last_name(@controller.view)
    assert(!test_result_name.empty?)
    assert_equal(test_result_name, dependency.name)

    test_type_string = @controller.class.send(:string_for_type, dependency.type)
    test_result_type = javascript_helper.last_type(@controller.view)
    assert(!test_result_type.empty?)
    assert_equal(test_result_type, test_type_string)

    test_result_installation = javascript_helper.last_installation(
      @controller.view
    )
    assert(test_result_installation.end_with?(test_installation))
  end

  def test_mutiple_missing_dependencies
    test_installation = 'Using <a href="http://brew.sh/">Homebrew</a>,'\
      ' <code>brew install asdf</code>'
    dependency_with_installation = Repla::Dependencies::Dependency.new(
      'asdf', :shell_command, installation_instructions: test_installation
    )
    dependency = Repla::Dependencies::Dependency.new('asdf', :shell_command)

    test_count_type = 4
    test_count_name = test_count_type
    test_count_installation = 3
    @controller.missing_dependency(dependency_with_installation)
    @controller.missing_dependency(dependency)
    @controller.missing_dependency(dependency_with_installation)
    @controller.missing_dependency(dependency_with_installation)

    javascript_helper = Repla::Dependencies::Tests::JavaScriptHelper
    test_result_count_name = javascript_helper.count_name(@controller.view)
    test_result_count_type = javascript_helper.count_type(@controller.view)
    test_result_count_installation = javascript_helper.count_installation(
      @controller.view
    )

    assert_equal(test_result_count_name, test_count_name)
    assert_equal(test_result_count_type, test_count_type)
    assert_equal(test_result_count_installation, test_count_installation)
  end
end
