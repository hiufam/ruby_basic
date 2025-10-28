module Enumerable
  # Your code goes here

  def my_all?(&block)
    eles = []
    each do |ele|
      eles << ele if block.call(ele)
    end

    eles.length == length
  end

  def my_any?(&block)
    each do |ele|
      return true if block.call(ele)
    end

    false
  end

  def my_count(&block)
    count = 0

    return length unless block_given?

    each do |ele|
      count += 1 if block.call(ele)
    end
    count
  end

  def my_each_with_index(&block)
    index = 0
    each do |ele|
      block.call(ele, index)

      index += 1
    end
  end

  def my_inject(init, &block)
    acc = init

    each do |ele|
      acc = block.call(acc, ele)
    end

    acc
  end

  def my_map(&block)
    eles = []

    each do |ele|
      eles << block.call(ele)
    end

    eles
  end

  def my_none?(&block)
    each do |ele|
      return false if block.call(ele)
    end

    true
  end

  def my_select(&block)
    eles = []

    each do |ele|
      eles << ele if block.call(ele)
    end

    eles
  end
end

# You will first have to define my_each
# on the Array class. Methods defined in
# your enumerable module will have access
# to this method
class Array
  # Define my_each here

  def my_each(&block)
    for ele in self do # rubocop:disable Style/For
      block.call(ele)
    end
  end
end
