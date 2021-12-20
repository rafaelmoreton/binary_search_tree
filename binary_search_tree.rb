# frozen_string_literal: true

# Used to store the each node's data, as well as it's childrens
class Node
  include Comparable
  attr_reader :data, :left, :right

  def initialize(data, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
    p "data: #{data}"
    p "left: #{left}, right: #{right}"
  end

  def <=>(other)
    data <=> other.data
  end
end

# Accepts an array when initialized. The Tree class have a root attribute which
# uses the return value of #build_tree.
class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array)
    return Node.new(array[0]) if array.size == 1

    # return nil if array[0].nil?

    left = Tree.new(array[0..array.size / 2 - 1])
    right = Tree.new(array[array.size / 2 + 1..array.size - 1])
    @root = Node.new(array[array.size / 2], left.root.data, right.root.data)
  end
end

Tree.new([1, 3, 4, 6, 9, 20, 23])
