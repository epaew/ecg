# frozen_string_literal: true

module ECG
  class Store
    def initialize(hash)
      map = hash.map { |k, v| [k.to_sym, transform_value(v)] }
      @store = map.to_h
    end

    def initialize_copy(obj)
      super
      @store = @store.dup
    end

    def binding
      super # NOTE: Kernel.#binding is private
    end

    def inspect
      detail = @store.map { |k, v| " @#{k}=#{v.inspect}" }.join(',')
      "#<#{self.class}:#{object_id << 1}#{detail}>"
    end

    def method_missing(name, *args)
      name = name.to_sym

      if @store.key?(name)
        transform_value(@store[name])
      elsif @store.respond_to?(name)
        @store.public_send(name, *args)
      else
        super
      end
    end

    def respond_to_missing?(symbol, include_private = false)
      symbol = symbol.to_sym

      @store.key?(symbol) || @store.respond_to?(symbol) || super
    end

    def to_h
      @store.transform_values do |value|
        case value
        when self.class
          value.to_h
        when Array
          value.map do |element|
            element.respond_to?(:to_h) ? element.to_h : element
          end
        else
          value
        end
      end
    end

    def to_json(*args)
      require 'json'
      to_h.to_json(args)
    end

    private

    def transform_value(value)
      case value
      when Hash
        self.class.new(value)
      when Array
        value.map(&method(:transform_value))
      else
        value
      end
    end
  end
end
