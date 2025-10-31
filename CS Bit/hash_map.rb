# frozen_string_literal: true

require_relative 'linked_list'

# Hashmap
class HashMap # rubocop:disable Metrics/ClassLength
  attr_accessor :max_load_factor, :load_factor, :capacity, :buckets, :entries_count

  def initialize
    @max_load_factor = 0.75
    @load_factor = 0
    @entries_count = 0
    @capacity = 16
    @buckets = Array.new(@capacity)
  end

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    hash_code
  end

  def set(key, value)
    hash_code = hash(key)

    index = hash_code % @buckets.length
    insert(index, key, value)

    @load_factor = @entries_count.to_f / @capacity

    return unless @load_factor >= @max_load_factor

    @capacity *= 2
    temp_buckets = @buckets
    @buckets = Array.new(@capacity)

    rehash(temp_buckets)
  end

  def get(key)
    hash_code = hash(key)
    index = hash_code % @buckets.length

    linked_list = @buckets[index]

    node_index = linked_list.find(key) { |node, _| node.value[:key] == key }
    node = linked_list.at(node_index)

    node.value[:value] unless node.nil?
  end

  def has?(key)
    !get(key).nil?
  end

  def rehash(old_buckets)
    @entries_count = 0

    old_buckets.each do |bucket|
      next if bucket.nil?

      # p bucket
      bucket.traverse do |_, node|
        obj = node.value
        index = hash(obj[:key]) % @buckets.length

        insert(index, obj[:key], obj[:value])
      end
    end
  end

  def remove(key)
    hash_code = hash(key)
    index = hash_code % @buckets.length

    linked_list = @buckets[index]

    return nil if linked_list.size < 1 # rubocop:disable Style/ZeroLengthPredicate

    temp = ''
    if linked_list.size == 1
      temp = linked_list.at(0)
      @buckets[index] = nil

    else
      node_index = linked_list.find(key) { |node, _| node.value[:key] == key }

      temp = linked_list.at(node_index)
      linked_list.remove_at(node_index)

    end

    @entries_count -= 1
    temp.value[:value]
  end

  def length
    @entries_count
  end

  def clear
    @entries_count = 0
    @load_factor = 0
    @capacity = 16
    @buckets = Array.new(@capacity)
  end

  def keys
    hm_keys = []
    traverse_buckets { |_, obj| hm_keys << obj[:key] }

    hm_keys
  end

  def values
    hm_values = []
    traverse_buckets { |_, obj| hm_values << obj[:value] }

    hm_values
  end

  def entries
    hm_enties = []
    traverse_buckets { |_, obj| hm_enties << [obj[:key], obj[:value]] }

    hm_enties
  end

  def traverse_buckets(&block)
    @buckets.each_with_index do |bucket, index|
      next if bucket.nil?

      # p bucket
      bucket.traverse do |_, node|
        obj = node.value
        block.call(index, obj)
      end
    end
  end

  def insert(index, key, value)
    raise IndexError if index.negative? || index >= @buckets.length

    obj = {
      key: key,
      value: value
    }

    if @buckets[index].nil?
      linked_list = LinkedList.new

      linked_list.append(obj)
      @entries_count += 1

      @buckets[index] = linked_list

    else
      linked_list = @buckets[index]

      node_index = linked_list.find(key) { |node, _| node.value[:key] == key }
      node = linked_list.at(node_index)

      if !node.nil?
        # overwrite existing value
        node.value[:value] = value
      else
        @buckets[index].append(obj)
        @entries_count += 1
      end
    end
  end
end

test = HashMap.new
test.set('apple', 'red')
test.set('banana', 'yellow')
test.set('carrot', 'orange')
test.set('dog', 'brown')
test.set('elephant', 'gray')
test.set('frog', 'green')
test.set('grape', 'purple')
test.set('hat', 'black')
test.set('ice cream', 'white')
test.set('jacket', 'blue')
test.set('kite', 'pink')
test.set('lion', 'golden')
test.set('we', 'golden 123')
