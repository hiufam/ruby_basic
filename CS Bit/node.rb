# frozen_string_literal: true

# Node
class Node
  attr_accessor :value, :next_node

  def initialize(value)
    @value = value
    @next_node = nil
  end

  def to_s
    puts "Node: #{value}"
  end
end
