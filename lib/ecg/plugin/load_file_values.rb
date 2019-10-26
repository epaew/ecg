# frozen_string_literal: true

require_relative '../option_parser'

module ECG
  module Plugin
    module LoadFileValues
      class LoadError < ::StandardError; end

      private

      def setup
        super

        parser = OptionParser.instance
        parser.args.inject(@values) do |result, path|
          result.merge!(load_file(path))
        end
        self
      end

      def load_file(path)
        case File.extname(path)
        when '.json'
          require 'json'
          File.open(path) { |f| JSON.parse(f.read) }
        when /\A\.ya?ml\z/
          require 'yaml'
          # NOTE: YAML.safe_load's non-keyword arguments are deprecated in 2.6
          # File.open(path) { |f| YAML.safe_load(f.read, aliases: true) }
          File.open(path) { |f| YAML.safe_load(f.read, [], [], true) }
        else
          raise LoadError,
                "Cannot load file `#{path}`. Only JSON/YAML are allowed."
        end
      end
    end
  end
end
