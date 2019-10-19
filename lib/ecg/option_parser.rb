# frozen_string_literal: true

require 'optparse'
require_relative 'store'

module ECG
  class LoadError < ::StandardError; end

  class OptionParser
    attr_reader :args, :option

    def initialize(args = [])
      @args = args
      @option = {}
    end

    def parse!
      print_help(false) if @args.empty?

      parser.parse!(@args)
      print_help(false) if @args.length > 1

      Store.new(hash)
    end

    private

    def banner
      <<~__BANNER__
        Usage: ecg [config.{json,yaml}] [options]
      __BANNER__
    end

    def hash
      hash = @args.empty? ? {} : load_file(@args.first)

      hash.merge(@option)
    end

    def load_file(path)
      case File.extname(path)
      when '.json'
        require 'json'
        File.open(path) { |f| JSON.parse(f.read) }
      when /\A\.ya?ml\z/
        require 'yaml'
        File.open(path) { |f| YAML.safe_load(f.read, [], [], true) }
      else
        raise ArgumentError,
              "Cannot load file `#{path}`. Only JSON/YAML are allowed."
      end
    end

    def parser
      ::OptionParser.new do |opt|
        opt.banner = banner

        opt.on('-v', '--values Key=Value', <<~__DESC__) do |str|
          Set the key-value mapping to be embedded in the template.
        __DESC__

          key, value = str.split('=', 2)
          @option[key] = value
        end
        opt.on('-V', '--version', 'Print version information') do
          puts "#{File.basename($PROGRAM_NAME)} #{ECG::VERSION}"
          exit
        end
        opt.on('-h', '--help', 'Print this help message', &method(:print_help))
      end
    end

    def print_help(bool)
      warn parser.help
      exit bool
    end
  end
end
