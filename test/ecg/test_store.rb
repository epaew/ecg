# frozen_string_literal: true

require 'test_helper'

module ECG
  class TestStore < Test::Unit::TestCase
    setup do
      @store = Store.new(key: 'value')
    end

    sub_test_case '#initialize' do
      def test_initialize_no_collection
        assert_equal(@store, Store.new(key: 'value'))
      end

      def test_initialize_array
        @store = Store.new(key: %w[value1 value2])

        assert_equal(@store, Store.new(key: %w[value1 value2]))
      end

      def test_initialize_hash
        @store = Store.new(key: { nested_key: 'nested_value' })

        assert_equal(@store.key, Store.new(nested_key: 'nested_value'))
      end

      def test_initialize_hash_in_array
        array_of_hash =
          [{ nested_key1: 'nested_value1' }, { nested_key2: 'nested_value2' }]
        @store = Store.new(key: array_of_hash)

        assert_equal(@store.key,
                     [Store.new(nested_key1: 'nested_value1'),
                      Store.new(nested_key2: 'nested_value2')])
      end
    end

    sub_test_case '#initialize_copy' do
      def test_dup
        store_dup = @store.dup

        assert_equal(store_dup, @store)            # check each key/value set
        refute(store_dup.to_h.equal?(@store.to_h)) # check different instance?
      end
    end

    sub_test_case '#binding' do
      # TODO
    end

    sub_test_case '#inspect' do
      def test_inspect
        assert_equal(@store.inspect,
                     %(#<ECG::Store:#{@store.object_id << 1} @key="value">))
      end
    end

    sub_test_case '#merge' do
      def test_simple_merge
        assert_equal(@store.merge(key2: 'value2'),
                     Store.new(key: 'value', key2: 'value2'))
        assert_equal(@store, Store.new(key: 'value'))
      end

      def test_deep_merge_array
        @store = Store.new(key: ['value'])
        # NOTE: fully replace
        assert_equal(@store.merge(key: %w[value2 value3]),
                     Store.new(key: %w[value2 value3]))
      end

      def test_deep_merge_hash
        @store = Store.new(root: { key: 'value' })
        assert_equal(@store.merge(root: { key2: 'value2' }),
                     Store.new(root: { key: 'value', key2: 'value2' }))
      end

      def test_deep_merge_store
        @store = Store.new(root: { key: 'value' })
        assert_equal(@store.merge(Store.new(root: { key2: 'value2' })),
                     Store.new(root: { key: 'value', key2: 'value2' }))
      end
    end

    sub_test_case '#merge!' do
      def test_merge!
        assert_equal(@store.merge!(key2: 'value2'),
                     Store.new(key: 'value', key2: 'value2'))
        assert_equal(@store, Store.new(key: 'value', key2: 'value2'))
      end
    end

    sub_test_case '#method_missing / #respond_to_missing?' do
      def test_respond_to
        assert_respond_to(@store, :key)
        assert_respond_to(@store, :[])
        assert_not_respond_to(@store, :undefined_method)
      end

      def test_method_missing
        assert_equal(@store.key, 'value')             # key?
        assert_equal(@store[:key], 'value')           # respond_to?
        assert_raise(NoMethodError) { @store.no_key } # else
      end
    end

    sub_test_case '#to_h' do
      def test_to_h_no_collection
        assert_equal(@store.to_h, key: 'value')
      end

      def test_to_h_array
        @store = Store.new(key: %w[value1 value2])

        assert_equal(@store.to_h, key: %w[value1 value2])
      end

      def test_to_h_hash
        @store = Store.new(key: { nested_key: 'nested_value' })

        assert_equal(@store.to_h, key: { nested_key: 'nested_value' })
      end

      def test_to_h_hash_in_array
        array_of_hash =
          [{ nested_key1: 'nested_value1' }, { nested_key2: 'nested_value2' }]
        @store = Store.new(key: array_of_hash)

        assert_equal(@store.to_h,
                     key: [
                       { nested_key1: 'nested_value1' },
                       { nested_key2: 'nested_value2' }
                     ])
      end
    end

    sub_test_case '#to_json' do
      # TODO
    end
  end
end
