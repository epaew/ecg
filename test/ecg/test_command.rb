# frozen_string_literal: true

require 'test_helper'

module ECG
  class TestCommand < Test::Unit::TestCase
    setup do
      $stdout = @stdout = StringIO.new
      $stderr = @stderr = StringIO.new
    end

    teardown do
      $stdout = STDOUT
      $stderr = STDERR
    end

    sub_test_case 'run with valid arguments' do
      def test_run_with_valid_arguments
        @stdin = StringIO.new(<<~__ERB__)
          {"name":"<%= name %>"}
        __ERB__

        run_command(['--values', 'name=epaew'])
        assert_equal(@stdout.string, <<~__RESULT__)
          {"name":"epaew"}
        __RESULT__
      end
    end

    sub_test_case 'run without arguments' do
      def test_run_with_no_arguments
        assert_raise(SystemExit) { run_command }
        assert_equal(@stderr.string, OptionParser.new.send(:parser).help)
      end
    end

    private

    def run_command(args = [])
      @command = Command.new(args)
      @command.execute(@stdin, @stdout)
    end
  end
end
