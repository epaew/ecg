# frozen_string_literal: true

require_relative '../option_parser'

module ECG
  module Plugin
    module LoadOptionValues
      class LoadError < ::StandardError; end

      class << self
        attr_reader :option_values

        def prepended(_mod)
          return if instance_variable_defined?(:@option_values)

          @option_values = {}
          parser = OptionParser.instance

          parser.on('-v', '--values Key=Value', <<~__DESC__) do |str|
            Set the key-value mapping to be embedded in the template.
          __DESC__

            @option_values.store(*str.split('=', 2))
          end
        end
      end

      private

      def setup
        super

        @values.merge!(
          transform_values(LoadOptionValues.option_values)
        )
        self
      end

      def transform_values(option_values)
        option_values.inject({}) do |result, (key, value)|
          keys = key.split('.').map(&:to_sym)

          if keys.count == 1
            set_single_option_value(result, keys.first, value)
          else
            set_nested_option_value(result, keys, value)
          end
        end
      end

      def set_single_option_value(option_values, key, value)
        if option_values[key].is_a? Hash
          raise LoadError, 'Reaf keys cannot have own value.'
        end

        option_values[key] = value
        option_values
      end

      def set_nested_option_value(option_values, keys, value)
        last_key = keys.pop

        nested = keys.inject(option_values) do |result, key|
          result[key] ||= {}
          unless result[key].is_a? Hash
            raise LoadError, 'Reaf keys cannot have own value.'
          end

          result[key]
        end
        nested[last_key] = value
        option_values
      end
    end
  end
end
