# frozen_string_literal: true

# Used to store each node's data and left 'n right pointers
class Node
  attr_accessor :data, :left, :right

  def initialize(value, left = nil, right = nil)
    @data = value
    @left = left
    @right = right
  end
end

# Stores the root of the tree, which comes from #build_tree
class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array)
    return Node.new(array[0]) if array.size == 1
    return nil if array.empty?

    left_node = build_tree(array[0..array.size / 2 - 1])
    right_node = build_tree(array[array.size / 2 + 1..array.size])
    Node.new(array[array.size / 2], left_node, right_node)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value, node = @root)
    return if value == node.data
    return node.left = Node.new(value) if value < node.data && node.left.nil?
    return node.right = Node.new(value) if value > node.data && node.right.nil?

    if value < node.data
      insert(value, node.left)
    else
      insert(value, node.right)
    end
  end

  def delete(value, node = @root, parent = nil)
    return if value != node.data && node.right.nil? && node.left.nil?
    return parent.left = nil if node.data == value && node.right.nil? && node.left.nil? && parent.left == node
    return parent.right = nil if node.data == value && node.right.nil? && node.left.nil? && parent.right == node
    return parent.right = node.right if value == node.data && node.right && node.left.nil?
    return parent.left = node.left if value == node.data && node.left && node.right.nil?

    if value == node.data && node.left && node.right
      next_node_value = min_successor(node.right).data
      delete(next_node_value)
      node.data = next_node_value
      return
    end

    if value < node.data
      delete(value, node.left, node)
    else
      delete(value, node.right, node)
    end
  end

  def min_successor(node)
    return node if node.left.nil?

    min_successor(node.left)
  end

  def find(value, node = @root)
    return node if node.data == value
    return if node.data > value && node.left.nil?
    return if node.data < value && node.right.nil?

    if node.data > value
      find(value, node.left)
    else
      find(value, node.right)
    end
  end

  def level_order(queue = [@root], level_order_list = [], &block)
    if queue.empty?
      if block_given?
        level_order_list.each do |node|
          yield node
        end
      else
        p level_order_list.map(&:data)
      end
      return
    end

    queue.size.times do
      level_order_list << queue[0]
      queue << queue[0].left if queue[0].left != nil
      queue << queue[0].right if queue[0].right != nil
      queue.delete_at(0)
    end
    level_order(queue, level_order_list, &block)
  end

#   def preorder(node = @root, preorder_list = [])
#     preorder_list << node
#     preorder(node.left, preorder_list) if node.left
#     preorder(node.right, preorder_list) if node.right
#     if block_given? && node == root
#       preorder_list.each do |node|
#         yield node
#       end
#     else
#       p preorder_list.map(&:data)
#     end
#   end
end

test = Tree.new([3, 5, 6, 8, 11, 15, 18])
test.pretty_print
test.preorder
