# frozen_string_literal: true

require 'erb'
require_relative 'option_parser'
require_relative 'store'

module ECG
  class Command
    def initialize(args)
      parser = OptionParser.new(args)
      @store = parser.parse!
    end

    def execute(input = $stdin, output = $stdout)
      output.puts ERB.new(input.read).result(@store.binding)
    end
  end
end
