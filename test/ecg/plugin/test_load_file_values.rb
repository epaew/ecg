# frozen_string_literal: true

require 'test_helper'

module ECG
  module Plugin
    class TestLoadFileValues < Test::Unit::TestCase
      setup do
        @context = Context.send(:new)
      end

      sub_test_case 'values from file' do
        def test_load_missing_file
          assert_raise(Errno::ENOENT) { setup_context('missing.yaml') }
        end

        def test_load_json_file
          setup_context(
            File.expand_path('../../fixtures/single_config.json', __dir__)
          )

          assert_equal(@context.values, Store.new(name: 'json'))
        end

        def test_load_yaml_file
          setup_context(
            File.expand_path('../../fixtures/single_config.yaml', __dir__)
          )

          assert_equal(@context.values, Store.new(name: 'yaml'))
        end

        def test_load_toml_file
          assert_raise(Plugin::LoadFileValues::LoadError) do
            setup_context(
              File.expand_path('../../fixtures/single_config.toml', __dir__)
            )
          end
        end

        def test_load_json_and_yaml_file
          setup_context(
            File.expand_path('../../fixtures/single_config.json', __dir__),
            File.expand_path('../../fixtures/single_config.yaml', __dir__)
          )

          assert_equal(@context.values, Store.new(name: 'yaml'))
        end

        def test_load_yaml_and_json_file
          setup_context(
            File.expand_path('../../fixtures/single_config.yaml', __dir__),
            File.expand_path('../../fixtures/single_config.json', __dir__)
          )

          assert_equal(@context.values, Store.new(name: 'json'))
        end
      end

      private

      def setup_context(*args)
        parser = @context.parser
        parser.instance_variable_set(:@args, args)
        parser.parse!
        @context.send(:setup)
      end
    end
  end
end
