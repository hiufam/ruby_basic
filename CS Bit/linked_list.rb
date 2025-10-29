# frozen_string_literal: true

require_relative 'node'

# Node
class LinkedList
  attr_accessor :head, :tail

  def append(value)
    new_node = Node.new(value)

    if head.nil?
      @head = new_node
      @tail = new_node
      return
    end

    @tail.next_node = new_node
    @tail = new_node
  end

  def prepend(value)
    new_node = Node.new(value)

    if head.nil?
      @head = new_node
      @tail = new_node
      return
    end

    new_node.next_node = @head
    @head = new_node
  end

  def traverse(index = nil, &block)
    return nil if @head.nil?

    flag_node = @head
    flag_index = 0

    until flag_node.nil? || (!index.nil? && flag_index > index)
      block.call(flag_index, flag_node) if block_given?

      return [flag_index, flag_node] if flag_index == index

      flag_node = flag_node.next_node
      flag_index += 1
    end

    [flag_index, nil]
  end

  def size
    traverse[0]
  end

  def at(index)
    _, node = traverse(index)
    node
  end

  def pop
    second_to_last = traverse(size - 2)[1]
    second_to_last.next_node = nil
  end

  def contain?(value)
    traverse { |_, node| return true if node.value == value }
    false
  end

  def find(value)
    traverse { |index, node| return index if node.value == value }
    nil
  end

  def to_s
    return 'nil' if @head.nil?

    str = "( #{@head.value} )"

    traverse do |_, node|
      str << if node.next_node.nil?
               ' -> nil'
             else
               " -> ( #{node.next_node.value} )"
             end
    end

    str
  end

  def insert_at(value, index) # rubocop:disable Metrics/AbcSize
    new_node = Node.new(value)

    if head.nil?
      @head = new_node
      @tail = new_node
      return
    end

    front_node = traverse(index - 1)[1]
    behind_node = traverse(index)[1]

    return append(value) if index > size - 1
    return prepend(value) if index.zero?

    front_node.next_node = new_node unless front_node.nil?
    new_node.next_node = behind_node unless behind_node.nil?
    nil
  end

  def remove_at(index)
    return nil if index > size - 1 || size.negative?

    front_node = traverse(index - 1)[1]
    behind_node = traverse(index + 1)[1]

    front_node.next_node = behind_node
  end
end
