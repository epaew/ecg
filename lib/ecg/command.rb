# frozen_string_literal: true

require 'erb'
require_relative 'option_parser'

module ECG
  class Command
    def initialize
      @context = Context.instance
    end

    def execute
      @context.parser.parse!
      # NOTE: ERB.new's non-keyword arguments are deprecated in 2.6
      # erb = ERB.new(input.read, trim_mode: context.trim_mode)
      @context.targets.each do |input, output|
        erb = ERB.new(input.read, nil, @context.trim_mode)
        output.puts erb.result(@context.binding)
      end
    end
  end
end
