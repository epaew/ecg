# frozen_string_literal: true

require 'test_helper'

module ECG
  class TestOptionParser < Test::Unit::TestCase
    setup do
      @original_argv = ARGV
      $stdout = @stdout = StringIO.new
      $stderr = @stderr = StringIO.new
    end

    teardown do
      Object.send(:remove_const, :ARGV)
      Object.const_set(:ARGV, @original_argv)

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
        assert_equal(parser_options[:trim_mode], '%')
      end

      def test_print_version_with_long_argument
        parse('--trim-mode', '%-')
        assert_equal(parser_options[:trim_mode], '%-')
      end
    end

    sub_test_case 'parse named argument' do
      def test_parse_short_named_values
        parse('-v', 'key=value')
        assert_equal(parser_options[:values], key: 'value')
      end

      def test_parse_long_named_values
        parse('--values', 'key=value')
        assert_equal(parser_options[:values], key: 'value')
      end
    end

    sub_test_case 'parse named argument with key includes `.`' do
      def test_parse_valid_nested_values
        parse('-v', 'nest1.nest2.nest3=value')
        assert_equal(parser_options[:values],
                     nest1: { nest2: { nest3: 'value' } })
      end

      def test_parse_multiple_valid_nested_values
        parse('-v', 'key=value',
              '-v', 'nest1.nest2.nest3.key=value',
              '-v', 'nest1.key=value',
              '-v', 'nest1.nest2.key=value')

        assert_equal(parser_options[:values],
                     key: 'value',
                     nest1: { key: 'value',
                              nest2: { key: 'value',
                                       nest3: { key: 'value' } } })
      end
    end

    sub_test_case 'parse named invalid argument with key includes `.`' do
      def test_parse_invalid_nested_values
        assert_raise(ArgumentError) do
          parse('-v', 'nest1=value',
                '-v', 'nest1.nest2.nest3=value')
        end
      end

      def test_parse_invalid_nested_values_rev
        assert_raise(ArgumentError) do
          parse('-v', 'nest1.nest2.nest3=value',
                '-v', 'nest1=value')
        end
      end
    end

    sub_test_case 'parse no arguments' do
      def test_parse_with_no_arguments
        assert_raise(SystemExit) { parse }
        assert_equal(@stderr.string, @parser.help)
      end
    end

    sub_test_case 'parse single unnamed arguments' do
      setup do
        @json_config =
          File.expand_path('../fixtures/single_config.json', __dir__)
        @toml_config =
          File.expand_path('../fixtures/single_config.toml', __dir__)
        @yaml_config =
          File.expand_path('../fixtures/single_config.yaml', __dir__)
      end

      def test_parse_with_single_json_file
        parse(@json_config)
        assert_equal(parser_options[:filepath], @json_config)
      end

      def test_parse_with_single_yaml_file
        parse(@yaml_config)
        assert_equal(parser_options[:filepath], @yaml_config)
      end

      def test_parse_with_single_toml_file
        assert_raise(ArgumentError) { parse(@toml_config) }
      end
    end

    sub_test_case 'parse multiple unnamed arguments' do
      setup do
        @json_config =
          File.expand_path('../fixtures/single_config.json', __dir__)
        @yaml_config =
          File.expand_path('../fixtures/single_config.yaml', __dir__)
      end

      def test_parse_with_two_or_more_arguments
        assert_raise(SystemExit) { parse(@json_config, @yaml_config) }
        assert_equal(@stderr.string, @parser.help)
      end
    end

    private

    def parse(*args)
      Object.send(:remove_const, :ARGV)
      Object.const_set(:ARGV, args)

      @parser = OptionParser.send(:new)
      @parser.send(:parse!)
    end

    def parser_options
      @parser.instance_variable_get(:@options)
    end
  end
end
