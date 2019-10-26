# frozen_string_literal: true

require 'test_helper'

module ECG
  module Plugin
    class TestLoadOptionValues < Test::Unit::TestCase
      setup do
        @context = Context.send(:new)
        LoadOptionValues.instance_variable_set(:@option_values, {})
      end

      sub_test_case 'values from option' do
        def test_load_option
          setup_context(name: 'option')

          assert_equal(@context.values, Store.new(name: 'option'))
        end

        def test_load_valid_nested_option
          setup_context('root.name': 'option')

          assert_equal(@context.values, Store.new(root: { name: 'option' }))
        end

        def test_load_invalid_nested_values
          assert_raise(LoadOptionValues::LoadError) do
            setup_context(root: 'value', 'root.nest': 'value')
          end
        end

        def test_load_invalid_nested_values_rev
          assert_raise(LoadOptionValues::LoadError) do
            setup_context('root.nest': 'value', root: 'value')
          end
        end
      end

      private

      def setup_context(**options)
        parser = @context.parser
        parser.instance_variable_set(
          :@args,
          options.flat_map { |key, value| ['--values', "#{key}=#{value}"] }
        )
        parser.parse!
        @context.send(:setup)
      end
    end
  end
end
