# frozen_string_literal: true

require 'optparse'
require 'singleton'
require_relative 'version'

module ECG
  class OptionParser < ::OptionParser
    include Singleton
    attr_reader :args, :trim_mode

    def initialize
      super

      @args = ARGV.dup
      @trim_mode = '<>'

      on_tail(
        '-t', '--trim-mode MODE', %(Set ERB's trim_mode. Default is "<>".)
      ) do |v|
        @trim_mode = v
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
    end

    def version
      VERSION
    end

    private

    def print_help(bool)
      Kernel.warn help
      exit bool
    end
  end
end
