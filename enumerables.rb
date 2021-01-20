# rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/ModuleLength
module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    i = 0
    while i < size
      if is_a? Array
        yield self[i]
      elsif is_a? Hash
        yield [keys[i], self[keys[i]]]
      elsif is_a? Range
        yield to_a[i]
      end
      i += 1
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    i = 0
    while i < size
      yield to_a[i], i
      i += 1
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    result = []
    to_a.my_each { |e| result << e if yield e }
    result
  end

  def my_all?(pattern = (pattern_not_defined = true))
    my_each do |item|
      if block_given?
        return false unless yield(item)
      elsif pattern_not_defined
        return false unless item
      elsif pattern.is_a?(Class)
        return false unless item.is_a?(pattern)
      elsif pattern.is_a?(Regexp)
        return false unless pattern.match?(item)
      else
        return false unless pattern == item
      end
    end
    true
  end

  def my_any?(pattern = (pattern_not_defined = true))
    my_each do |item|
      if block_given?
        return true if yield(item)
      elsif pattern_not_defined
        return true if item
      elsif pattern.is_a?(Class)
        return true if item.is_a?(pattern)
      elsif pattern.is_a?(Regexp)
        return true if pattern.match?(item)
      elsif pattern == item
        return true
      end
    end
    false
  end

  def my_none?(pattern = (pattern_not_defined = true))
    my_each do |item|
      if block_given?
        return false if yield(item)
      elsif pattern_not_defined
        return false if item
      elsif pattern.is_a?(Class)
        return false if item.is_a?(pattern)
      elsif pattern.is_a?(Regexp)
        return false if pattern.match?(item)
      elsif pattern == item
        return false
      end
    end
    true
  end

  def my_count(int = nil)
    count = 0
    if block_given?
      my_each { |e| count += 1 if yield e }
    elsif !int.nil?
      my_each { |e| count += 1 if e == int }
    else
      my_each { |_e| count += 1 }
    end
    count
  end

  def my_map(proc_arg = nil)
    return to_enum(:my_map) unless block_given? || !proc_arg.nil?

    ary = []
    if proc_arg.nil?
      my_each { |e| ary << (yield e) }
    else
      my_each { |e| ary << proc_arg.call(e) }
    end
    ary
  end

  def my_inject(arg = nil, sym = nil, &block)
    if block_given?
      result = arg unless arg.nil?
      my_each { |e| result = result.nil? ? result = e : yield(result, e) }
      result
    elsif arg.is_a?(Symbol)
      my_each { |e| result = result.nil? ? result = e : result.public_send(arg, e) }
      result
    elsif arg.is_a?(Numeric) && sym.is_a?(Symbol)
      result = arg
      my_each { |e| result = result.public_send sym, e }
      result
    else
      my_each { |_e| block.call }
    end
  end
end

def multiply_els(array)
  array.my_inject { |sum, n| sum * n }
end

# rubocop: enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/ModuleLength
