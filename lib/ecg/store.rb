# frozen_string_literal: true

module ECG
  class Store
    def initialize(values = {})
      @values = values.map { |k, v| [k.to_sym, transform_value(v)] }.to_h
    end

    def initialize_copy(obj)
      super
      @values = @values.dup
    end

    def binding
      super # NOTE: Kernel.#binding is private
    end

    def inspect
      detail = @values.map { |k, v| " @#{k}=#{v.inspect}" }.join(',')
      "#<#{self.class}:#{object_id << 1}#{detail}>"
    end

    def merge(*others)
      others.inject(dup, &method(:deep_merge))
    end

    def merge!(*others)
      others.inject(self, &method(:deep_merge))
    end

    def method_missing(name, *args, &block)
      if @values.key?(name)
        @values[name]
      elsif @values.respond_to?(name)
        @values.public_send(name, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(name, include_private = false)
      @values.key?(name) || @values.respond_to?(name) || super
    end

    def store(key, value)
      @values.store(key.to_sym, transform_value(value))
    end
    alias []= store

    def to_h
      @values.transform_values(&method(:intransform_value))
    end

    def to_json(*args)
      require 'json'
      to_h.to_json(args)
    end

    def ==(other)
      return false unless other.is_a?(self.class)

      to_h == other.to_h
    end

    private

    def deep_merge(source, other)
      other.keys.each do |key|
        value = transform_value(other[key])

        if source[key].is_a?(Store) && value.is_a?(Store)
          source[key].merge!(value)
        elsif !value.nil?
          source[key] = value
        end
      end

      source
    end

    def intransform_value(value)
      case value
      when self.class
        value.to_h
      when Array
        value.map(&method(:intransform_value))
      else
        value
      end
    end

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
