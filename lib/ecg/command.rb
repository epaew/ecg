# frozen_string_literal: true

require 'erb'
require_relative 'option_parser'

module ECG
  class Command
    def initialize(args)
      @parser = OptionParser.new(args)
    end

    def execute(input = $stdin, output = $stdout)
      context = @parser.context
      # NOTE: ERB.new's non-keyword arguments are deprecated in 2.6
      # erb = ERB.new(input.read, trim_mode: context.trim_mode)
      erb = ERB.new(input.read, nil, context.trim_mode)
      output.puts erb.result(context.values.binding)
    end
  end
end
