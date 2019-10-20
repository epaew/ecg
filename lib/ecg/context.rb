# frozen_string_literal: true

require_relative 'store'

module ECG
  class Context
    attr_reader :trim_mode

    def initialize(filepath:, trim_mode:, values:)
      @trim_mode = trim_mode
      @values_file = filepath
      @values_option = values
    end

    def values
      Store.new(merged_hash)
    end

    private

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
        raise ArgumentError,
              "Cannot load file `#{path}`. Only JSON/YAML are allowed."
      end
    end

    def merged_hash
      hash = @values_file.nil? ? {} : load_file(@values_file)
      hash.merge(@values_option)
    end
  end
end
