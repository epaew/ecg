# frozen_string_literal: true

require 'test_helper'

module ECG
  class TestContext < Test::Unit::TestCase
    setup do
      @filepath = nil
      @trim_mode = '<>'
      @values = {}
    end

    sub_test_case 'values from file' do
      def test_load_missing_file
        @filepath = 'missing.yaml'
        generate_context

        assert_raise(Errno::ENOENT) { @context.values }
      end

      def test_load_json_file
        @filepath = File.expand_path('../fixtures/single_config.json', __dir__)
        generate_context

        assert_equal(@context.values, Store.new(name: 'epaew'))
      end

      def test_load_yaml_file
        @filepath = File.expand_path('../fixtures/single_config.yaml', __dir__)
        generate_context

        assert_equal(@context.values, Store.new(name: 'epaew'))
      end

      def test_load_toml_file
        @filepath = File.expand_path('../fixtures/single_config.toml', __dir__)
        generate_context

        assert_raise(ArgumentError) { @context.values }
      end
    end

    sub_test_case 'values from option' do
      def test_load_option
        @values = { name: 'epaew' }
        generate_context

        assert_equal(@context.values, Store.new(name: 'epaew'))
      end
    end

    sub_test_case 'values from file and option' do
      def test_load_file_and_option
        @filepath = File.expand_path('../fixtures/single_config.yaml', __dir__)
        @values = { name: 'override' }
        generate_context

        assert_equal(@context.values, Store.new(name: 'override'))
      end
    end

    private

    def generate_context
      @context = Context.new(
        filepath: @filepath,
        trim_mode: @trim_mode,
        values: @values
      )
    end
  end
end
