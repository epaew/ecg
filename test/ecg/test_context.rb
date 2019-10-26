# frozen_string_literal: true

require 'test_helper'

module ECG
  class TestContext < Test::Unit::TestCase
    setup do
      @context = Context.send(:new)
      Plugin::LoadOptionValues.instance_variable_set(:@option_values, {})
    end

    sub_test_case '#binding' do
      # TODO
    end

    sub_test_case '#method_missing / #respond_to_missing?' do
      def test_respond_to
        setup_context(name: 'context')

        assert_respond_to(@context, :key)
        assert_not_respond_to(@context, :undefined_key)
      end

      def test_method_missing
        setup_context(name: 'context')

        assert_equal(@context.name, 'context')
        assert_raise(NoMethodError) { @context.undefined_key }
      end
    end

    sub_test_case '#trim_mode' do
      def test_trim_mode
        setup_context('-t', '%')

        assert_equal(@context.trim_mode, '%')
      end
    end

    sub_test_case 'values from file and option' do
      def test_load_file_and_option
        setup_context(
          File.expand_path('../fixtures/single_config.yaml', __dir__),
          name: 'override'
        )

        assert_equal(@context.values, Store.new(name: 'override'))
      end
    end

    private

    def setup_context(*args, **options)
      parser = @context.parser
      @context.parser.instance_variable_set(:@args, args)
      parser.args.concat(
        options.flat_map { |key, value| ['--values', "#{key}=#{value}"] }
      )
      parser.parse!
      @context.send(:setup)
    end
  end
end
