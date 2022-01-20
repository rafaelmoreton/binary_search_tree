# frozen_string_literal: true

# Used to store each node's data and left 'n right pointers
class Node
  attr_accessor :data, :left, :right

  def initialize(value, left = nil, right = nil)
    @data = value
    @left = left
    @right = right
  end

  def leaf?
    left.nil? && right.nil? ? true : false
  end
end

# Stores the root of the tree, which comes from #build_tree
class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(array.uniq.sort)
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

  def preorder(node = @root, preorder_list = [])
    preorder_list << node
    preorder(node.left, preorder_list) if node.left
    preorder(node.right, preorder_list) if node.right
    if node == @root
      if block_given?
        preorder_list.each do |listed_node|
          yield listed_node
        end
      else
        preorder_list.map(&:data)
      end
    end
  end

  def inorder(node = @root, inorder_list = [])
    inorder(node.left, inorder_list) if node.left
    inorder_list << node
    inorder(node.right, inorder_list) if node.right
    if node == @root
      if block_given?
        inorder_list.each do |listed_node|
          yield listed_node
        end
      else
        inorder_list.map(&:data)
      end
    end
  end

  def postorder(node = @root, postorder_list = [])
    postorder(node.left, postorder_list) if node.left
    postorder(node.right, postorder_list) if node.right
    postorder_list << node
    if node == @root
      if block_given?
        postorder_list.each do |listed_node|
          yield listed_node
        end
      else
        postorder_list.map(&:data)
      end
    end
  end

  def height(value)
    find_leaves(find(value)).max { |a, b| a[1] <=> b[1]}[1]
  end

  def find_leaves(node = @root, leaves_list = [], edges = 0)
    if node&.leaf?
      return leaves_list << [node, edges]
    end
    return nil if node.nil?

    find_leaves(node.left, leaves_list, edges + 1)
    find_leaves(node.right, leaves_list, edges + 1)
    leaves_list
  end

  def depth(value, node = @root, edges = 0)
    return edges if node.data == value
    return if node.data > value && node.left.nil?
    return if node.data < value && node.right.nil?

    if node.data > value
      depth(value, node.left, edges + 1)
    else
      depth(value, node.right, edges + 1)
    end
  end

  def balanced?
    edges = (find_leaves.map { |node_array| node_array[1] }).minmax
    (edges[0] - edges[1]).abs <= 1
  end

  def rebalance
    @root = build_tree(inorder)
  end
end
