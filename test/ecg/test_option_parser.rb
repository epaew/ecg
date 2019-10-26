# frozen_string_literal: true

require 'test_helper'

module ECG
  class TestOptionParser < Test::Unit::TestCase
    setup do
      $stdout = @stdout = StringIO.new
      $stderr = @stderr = StringIO.new
    end

    teardown do
      $stdout = STDOUT
      $stderr = STDERR
    end

    sub_test_case 'print help to stderr' do
      def test_print_help_with_short_argument
        assert_raise(SystemExit) { parse('-h') }
        assert_equal(@stderr.string, @parser.help)
      end

      def test_print_help_with_long_argument
        assert_raise(SystemExit) { parse('--help') }
        assert_equal(@stderr.string, @parser.help)
      end
    end

    sub_test_case 'print version to stdout' do
      def test_print_version_with_short_argument
        assert_raise(SystemExit) { parse('-V') }
        assert_equal(@stdout.string.chomp, @parser.ver)
      end

      def test_print_version_with_long_argument
        assert_raise(SystemExit) { parse('--version') }
        assert_equal(@stdout.string.chomp, @parser.ver)
      end
    end

    sub_test_case "set erb's trim_mode" do
      def test_print_version_with_short_argument
        parse('-t', '%')
        assert_equal(@parser.trim_mode, '%')
      end

      def test_print_version_with_long_argument
        parse('--trim-mode', '%-')
        assert_equal(@parser.trim_mode, '%-')
      end
    end

    sub_test_case 'parse no arguments' do
      def test_parse_with_no_arguments
        assert_raise(SystemExit) { parse }
        assert_equal(@stderr.string, @parser.help)
      end
    end

    private

    def parse(*args)
      @parser = OptionParser.send(:new)
      @parser.instance_variable_set(:@args, args)
      @parser.send(:parse!)
    end
  end
end
