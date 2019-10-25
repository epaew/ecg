# frozen_string_literal: true

require 'test_helper'

module ECG
  class TestCommand < Test::Unit::TestCase
    setup do
      @original_argv = ARGV
      @stdin = $stdin
      $stdout = @stdout = StringIO.new
      $stderr = @stderr = StringIO.new
    end

    teardown do
      Object.send(:remove_const, :ARGV)
      Object.const_set(:ARGV, @original_argv)

      $stdout = STDOUT
      $stderr = STDERR
    end

    sub_test_case 'run with valid arguments' do
      def test_run_with_valid_arguments
        @stdin = StringIO.new(<<~__ERB__)
          {"name":"<%= name %>"}
        __ERB__

        run_command('--values', 'name=epaew')
        assert_equal(@stdout.string, <<~__RESULT__)
          {"name":"epaew"}
        __RESULT__
      end
    end

    sub_test_case 'run without arguments' do
      def test_run_with_no_arguments
        assert_raise(SystemExit) { run_command }
        assert_equal(@stderr.string, OptionParser.instance.help)
      end
    end

    private

    def run_command(*args)
      Object.send(:remove_const, :ARGV)
      Object.const_set(:ARGV, args)

      @command = Command.new
      @command.execute(@stdin, @stdout)
    end
  end
end
