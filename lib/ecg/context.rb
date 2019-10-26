# frozen_string_literal: true

require 'singleton'
require_relative 'store'
require_relative 'plugin/load_file_values'
require_relative 'plugin/load_option_values'

module ECG
  class Context
    include Singleton
    prepend Plugin::LoadFileValues
    prepend Plugin::LoadOptionValues

    attr_reader :parser, :targets, :values

    def initialize
      @parser = OptionParser.instance
      @targets = { $stdin => $stdout }
      @values = Store.new
    end

    def binding
      setup
      super # NOTE: Kernel.#binding is private
    end

    def method_missing(name, *args, &block)
      if @values.respond_to?(name)
        @values.public_send(name, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(name, include_private = false)
      @values.respond_to?(name) || super
    end

    def trim_mode
      @parser.trim_mode
    end

    private

    def setup; end
  end
end
