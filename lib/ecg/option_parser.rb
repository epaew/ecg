# frozen_string_literal: true

require 'optparse'
require 'singleton'
require_relative 'version'

module ECG
  class OptionParser < ::OptionParser
    include Singleton
    attr_reader :args, :options

    def initialize
      super

      @args = ARGV.dup
      @options = { filepath: nil, trim_mode: '<>', values: {} }

      on('-v', '--values Key=Value', <<~__DESC__) do |str|
        Set the key-value mapping to be embedded in the template.
      __DESC__

        set_option_value(*str.split('=', 2))
      end
      on('-t', '--trim-mode MODE', <<~__DESC__) do |v|
        Set ERB's trim_mode. Default is "<>".
      __DESC__

        @options[:trim_mode] = v
      end
      on_tail('-V', '--version', 'Print version information') do
        puts ver
        exit
      end
      on_tail('-h', '--help', 'Print this help message', &method(:print_help))
    end

    def banner
      'Usage: ecg [config.{json,yaml}] [options]'
    end

    undef_method :parse

    def parse!
      print_help(false) if @args.empty?

      super(@args)
      @options[:filepath] = filepath
    end

    def version
      VERSION
    end

    private

    def filepath
      print_help(false) if @args.length > 1
      return nil if @args.empty?

      path = @args.first
      extname = File.extname(path)
      if %w[.json .yml .yaml].none? { |ext| ext == extname }
        raise ArgumentError,
              "Cannot load file `#{path}`. Only JSON/YAML are allowed."
      end

      path
    end

    def print_help(bool)
      Kernel.warn help
      exit bool
    end

    def set_option_value(key, value)
      keys = key.split('.').map(&:to_sym)
      if keys.count == 1
        set_single_option_value(keys.first, value)
      else
        set_nested_option_value(keys, value)
      end
    end

    def set_single_option_value(key, value)
      values = @options[:values]
      if values[key].is_a? Hash
        raise ArgumentError, 'Reaf keys cannot have own value.'
      end

      values[key] = value
      values
    end

    def set_nested_option_value(keys, value)
      values = @options[:values]
      last_key = keys.pop

      nested = keys.inject(values) do |result, key|
        result[key] ||= {}
        unless result[key].is_a? Hash
          raise ArgumentError, 'Reaf keys cannot have own value.'
        end

        result[key]
      end
      nested[last_key] = value
      values
    end
  end
end
