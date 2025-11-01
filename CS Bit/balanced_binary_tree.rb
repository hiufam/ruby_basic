# frozen_string_literal: true

# Tree
class Tree
  attr_accessor :root

  Node = Struct.new(:data, :left, :right) do
    include Comparable

    def <=>(other)
      data <=> other.data
    end
  end

  def build_tree(elemets)
    sorted_eles = elemets.uniq.sort
    @root = binary_tree_recursive(sorted_eles)
  end

  def insert(value, root = @root)
    return Tree::Node.new(value) if root.nil?

    if value < root.data
      root.left = insert(value, root.left)
    else
      root.right = insert(value, root.right)
    end

    root
  end

  def delete(value, node = @root)
    return node if node.nil?

    if node.data == value
      if node.left.nil?
        temp = node.right
        node = nil
        return temp
      end

      if node.right.nil?
        temp = node.left
        node = nil
        return temp
      end

      succ = get_successor(node)
      node.data = succ.data
      node.left = delete(succ.data, node.left)
    end

    if value < node.data
      node.left = delete(value, node.left)
    elsif value > node.data
      node.right = delete(value, node.right)
    end

    node
  end

  def find(value, on_find = nil, node = @root, length = 0)
    return nil if node.nil?

    if value == node.data
      on_find&.call(length)

      return node
    end

    if value < node.data
      find(value, on_find, node.left, length + 1)
    elsif value > node.data
      find(value, on_find, node.right, length + 1)
    end
  end

  def level_order(node = @root, &block)
    return [] if node.nil?

    queue = [] << node
    arr = []

    until queue.empty?
      first_node = queue.shift
      arr << first_node.data

      block.call(first_node) if block_given?

      queue << first_node.left unless first_node.left.nil?
      queue << first_node.right unless first_node.right.nil?
    end

    arr
  end

  def preorder(node = @root, arr = [])
    return arr if node.nil?

    arr << node.data
    preorder(node.left, arr)
    preorder(node.right, arr)
  end

  def inorder(node = @root, arr = [])
    return arr if node.nil?

    inorder(node.left, arr)
    arr << node.data
    inorder(node.right, arr)
  end

  def postorder(node = @root, arr = [])
    return arr if node.nil?

    inorder(node.left, arr)
    inorder(node.right, arr)
    arr << node.data
  end

  def height(value)
    node = find(value)
    return nil if node.nil?

    height_by_nodes_recur(node) - 1
  end

  def depth(value)
    m_depth = nil
    call_back = ->(length) { m_depth = length }
    find(value, call_back)

    m_depth
  end

  def balanced?
    level_order do |node|
      left_height = node.left ? height(node.left.data) : 0
      right_height = node.right ? height(node.right.data) : 0

      diff = (left_height - right_height).abs
      return false if diff > 1
    end

    true
  end

  def rebalance(root = @root)
    sorted_arr = inorder(root)
    @root = build_tree(sorted_arr)
  end

  def height_by_nodes_recur(node)
    return 0 if node.nil?

    left_height = 1 + height_by_nodes_recur(node.left)
    right_height = 1 + height_by_nodes_recur(node.right)

    [left_height, right_height].max
  end

  def get_successor(curr)
    curr = curr.left
    curr = curr.right while !curr.nil? && !curr.right.nil?
    curr
  end

  def binary_tree_recursive(array)
    return Tree::Node.new(array[0]) if array.length == 1
    return nil if array.length == 0

    mid_index = (array.length - 1) / 2

    left_array = (mid_index - 1) >= 0 ? array[0..(mid_index - 1)] : []
    right_array = array[(mid_index + 1)..array.length]

    Tree::Node.new(array[mid_index], binary_tree_recursive(left_array), binary_tree_recursive(right_array))
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

tree = Tree.new

tree.build_tree(Array.new(15) { rand(1..100) })

p tree.balanced?
p tree.level_order
p tree.preorder
p tree.inorder
p tree.postorder

tree.insert(101)
tree.insert(102)

p tree.balanced?
tree.rebalance
tree.pretty_print

p tree.balanced?
