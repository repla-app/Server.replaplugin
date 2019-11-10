#!/usr/bin/env ruby

require 'minitest/autorun'

require_relative '../../dependencies'

require_relative 'lib/test_javascript_helper'

module Repla
  module Dependencies
    # Dependency checker test helper
    class Checker
      def close
        @controller.view.close if @controller
      end

      def view
        @controller.view
      end

      def controller_exists?
        !@controller.nil?
      end
    end
  end
end

# Test controller
class TestController < Minitest::Test
  def setup
    @checker = Repla::Dependencies::Checker.new
  end

  def teardown
    @checker.close
  end

  def test_missing_dependency
    dependency = Repla::Dependencies::Dependency.new('asdf', :shell_command)

    passed = @checker.check(dependency)

    assert(!passed, 'The check should have failed.')

    test_result_name = Repla::Dependencies::Tests::JavaScriptHelper.last_name(
      @checker.view
    )
    assert(!test_result_name.empty?)
    assert_equal(test_result_name, dependency.name)

    test_type_string = Repla::Dependencies::Controller.send(:string_for_type,
                                                            dependency.type)
    test_result_type = Repla::Dependencies::Tests::JavaScriptHelper.last_type(
      @checker.view
    )
    assert(!test_result_type.empty?)
    assert_equal(test_result_type, test_type_string)
  end

  def test_present_dependency
    dependency = Repla::Dependencies::Dependency.new('grep', :shell_command)

    passed = @checker.check(dependency)

    assert(passed)
    assert(!@checker.controller_exists?)
  end

  def test_mixed_dependencies
    test_installation = 'Using <a href="http://brew.sh/">Homebrew</a>,'\
      ' <code>brew install asdf</code>'
    passing_dependency = Repla::Dependencies::Dependency.new('grep',
                                                             :shell_command)
    failing_dependency = Repla::Dependencies::Dependency.new('asdf',
                                                             :shell_command)
    failing_dependency_with_installation = Repla::Dependencies::Dependency.new(
      'asdf', :shell_command, installation_instructions: test_installation
    )

    test_count_type = 2
    test_count_name = test_count_type
    test_count_installation = 1

    passed = @checker.check(passing_dependency)
    assert(passed, 'The check should have passed.')

    passed = @checker.check(failing_dependency)
    assert(!passed, 'The check should have failed.')

    passed = @checker.check(failing_dependency_with_installation)
    assert(!passed, 'The check should have failed.')

    assert(@checker.controller_exists?)

    javascript_helper = Repla::Dependencies::Tests::JavaScriptHelper
    test_result_count_name = javascript_helper.count_name(@checker.view)
    test_result_count_type = javascript_helper.count_type(@checker.view)
    test_result_count_installation = javascript_helper.count_installation(
      @checker.view
    )

    assert_equal(test_result_count_name, test_count_name)
    assert_equal(test_result_count_type, test_count_type)
    assert_equal(test_result_count_installation, test_count_installation)
  end

  def test_batch_mixed_dependencies
    test_installation = 'Using <a href="http://brew.sh/">Homebrew</a>,'\
      ' <code>brew install asdf</code>'
    passing_dependency = Repla::Dependencies::Dependency.new('grep',
                                                             :shell_command)
    failing_dependency = Repla::Dependencies::Dependency.new('asdf',
                                                             :shell_command)
    failing_dependency_with_installation = Repla::Dependencies::Dependency.new(
      'asdf', :shell_command, installation_instructions: test_installation
    )

    dependencies = [passing_dependency,
                    failing_dependency,
                    failing_dependency_with_installation]

    test_count_type = 2
    test_count_name = test_count_type
    test_count_installation = 1

    passed = @checker.check_dependencies(dependencies)
    assert(!passed, 'The check should have failed.')

    assert(@checker.controller_exists?)

    javascript_helper = Repla::Dependencies::Tests::JavaScriptHelper
    test_result_count_name = javascript_helper.count_name(@checker.view)
    test_result_count_type = javascript_helper.count_type(@checker.view)
    test_result_count_installation = javascript_helper.count_installation(
      @checker.view
    )

    assert_equal(test_result_count_name, test_count_name)
    assert_equal(test_result_count_type, test_count_type)
    assert_equal(test_result_count_installation, test_count_installation)
  end
end
