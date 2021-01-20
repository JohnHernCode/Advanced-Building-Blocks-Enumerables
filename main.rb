require_relative 'enumerables'

array_test = [1, 2, 3, 4, 5, 6]
obj_test = { one: 1, two: 2, three: 3 }

# Method call for tests each
puts '--------------Original each--------------------'
array_test.each { |e| p e**2 }
obj_test.each { |e| p e }

puts '--------------my_each--------------------------'
array_test.my_each { |e| p e**2 }
obj_test.my_each { |e| p e }

# Method call for tests each_with_index
puts '--------------Original each with index---------'
array_test.each_with_index { |e, i| p e, i }
obj_test.each_with_index { |e, i| p e, i }

puts '--------------my_each_with_index---------------'
array_test.my_each_with_index { |e, i| p e, i }
obj_test.my_each_with_index { |e, i| p e, i }

# Method call for tests Select
puts '---------------Original select-----------------'
p array_test.select(&:even?)
p(obj_test.select { |_k, v| v < 2 })

puts '---------------my_select-----------------------'
p array_test.my_select(&:even?)
p(obj_test.my_select { |_k, v| v < 2 })

# Method call for tests all?
puts '---------------Original all?-------------------'
p(array_test.all? { |e| e.is_a?(Integer) })

puts '---------------my_all?-------------------------'
p(array_test.my_all? { |e| e.is_a?(Integer) })

# Method call for tests any?
puts '---------------Original any?-------------------'
p(array_test.any? { |e| e.is_a?(Symbol) })

puts '---------------my_any?-------------------------'
p(array_test.my_any? { |e| e.is_a?(Symbol) })

# Method call for tests none?
puts '---------------Original none?------------------'
p(array_test.none? { |e| e.is_a?(Symbol) })
p [].none?
p [nil].none?
p [nil, false].none?
p [nil, false, true].none?

puts '---------------my_none?------------------------'
p(array_test.my_none? { |e| e.is_a?(Symbol) })
p [].my_none?
p [nil].my_none?
p [nil, false].my_none?
p [nil, false, true].my_none?

# Method call for tests count
puts '---------------Original count------------------'
ary = [1, 2, 4, 2]
p ary.count
p ary.count(2)
p(ary.count { |x| (x % 2).zero? })

puts '---------------my_count------------------------'
ary = [1, 2, 4, 2]
p ary.my_count
p ary.my_count(2)
p(ary.count { |x| (x % 2).zero? })

# Method call for tests map
puts '--------------Original map---------------------'
p((1..4).map { |i| i * i })
p(array_test.map { |i| i * i })

puts '--------------my_map---------------------------'
p((1..4).my_map { |i| i * i })
p(array_test.my_map { |i| i * i })
my_proc = proc { |i| i * i }
p((1..5).my_map(my_proc) { |i| i * i })

# Method call for tests inject
puts '-------------Original inject-------------------'
p((5..10).inject { |sum, n| sum + n })
p(array_test.inject { |sum, n| sum + n })

puts '-------------my_inject-------------------------'
p((5..10).my_inject { |sum, n| sum + n })
p(array_test.my_inject { |sum, n| sum + n })

# Method call for multiply_els
puts '-------------multiply_els----------------------'
p(multiply_els(array_test))

# Suggested tests

ARRAY_SIZE = 100
LOWEST_VALUE = 0
HIGHEST_VALUE = 9

array = Array.new(ARRAY_SIZE) { rand(LOWEST_VALUE...HIGHEST_VALUE) }
block = proc { |num| num < (LOWEST_VALUE + HIGHEST_VALUE) / 2 }
words = %w[dog door rod blade]
range = Range.new(5, 50)
search = proc { |memo, word| memo.length > word.length ? memo : word }
false_block = proc { |num| num > HIGHEST_VALUE }
true_array = [1, 2i, 3.14]
false_array = [nil, true, 99]
array_test = [1, 2, 3, 4, 5, 6]

p '----------------------each range---------------------------'
p(range.my_each(&block))
p(range.each(&block))
p '----------------------select range-------------------------'
p(range.my_select(&block))
p(range.select(&block))
p '----------------------all? range----------------------------'
p(range.all?(&false_block))
p(range.my_all?(&false_block))
p '----------------------all? array----------------------------'
p(array.all? { |num| num + 1 })
p(array.my_all? { |num| num + 1 })
p '----------------------all? Numeric class--------------------'
p true_array.all?(Numeric)
p(true_array.my_all?(Numeric))
p '----------------------all? true array-----------------------'
p true_array.all?
p(true_array.my_all?)
p '----------------------all? false Array----------------------'
p false_array.all?
p(false_array.my_all?)
p '----------------------all? Integer class--------------------'
p array.all?(Integer)
p(array.my_all?(Integer))
p '----------------------all? true Regex-----------------------'
p words.all?(/d/)
p(words.my_all?(/d/))
p '----------------------all? false Regex----------------------'
p words.all?(/o/)
p(words.my_all?(/o/))
p '----------------------all? input pattern--------------------'
p array_test.all?(3)
p(array_test.my_all?(3))
p '----------------------any? false block----------------------'
p(range.any?(&false_block))
p(range.my_any?(&false_block))
p '----------------------any? false array----------------------'
p false_array.any?
p(false_array.my_any?)
p '----------------------any? true array-----------------------'
p true_array.any?(Numeric)
p(true_array.my_any?(Numeric))
p '----------------------any? words array----------------------'
p words.any?(Integer)
p(words.my_any?(Integer))
p '----------------------any? Regex----------------------------'
p words.any?(/d/)
p(words.my_any?(/d/))
p '----------------------any? input pattern--------------------'
p words.any?('cat')
p words.my_any?('cat')
p '----------------------none? range---------------------------'
p range.none?(&false_block)
p range.my_none?(&false_block)
p '----------------------none? string--------------------------'
p array.none?(String)
p array.my_none?(String)
p '----------------------none? Numeric class-------------------'
p array.none?(Numeric)
p array.my_none?(Numeric)
p '----------------------none? String class--------------------'
p array.none?(String)
p array.my_none?(String)
p '----------------------none? true regex----------------------'
p words.none?(/z/)
p words.my_none?(/z/)
p '----------------------none? false regex---------------------'
p words.none?(/d/)
p words.my_none?(/d/)
p '----------------------none? pattern-------------------------'
p words.none?(5)
p words.my_none?(5)
p '----------------------count range---------------------------'
p range.count
p range.my_count
p '----------------------count array with argument-------------'
p array.count(LOWEST_VALUE)
p array.my_count(LOWEST_VALUE)
p '----------------------inject search-------------------------'
p words.count(search)
p words.my_count(search)
p '----------------------inject range--------------------------'
p range.inject(4) { |prod, n| prod * n }
p range.my_inject(4) { |prod, n| prod * n }
p '----------------------inject symbol + ----------------------'
p array.inject(:+)
p array.my_inject(:+)
p '----------------------inject symbol * ----------------------'
p array_test.inject(:*)
p array_test.my_inject(:*)
p '----------------------array inject 2 args-------------------'
p array_test.inject(20, :*)
p array_test.my_inject(20, :*)
p '----------------------array range 2 args--------------------'
p range.inject(2, :*)
p(range.my_inject(2, :*))

p '----------------------array all? true-----------------------'
p [true, true].all?
p [true, true].my_all?

p '----------------------array all? pattern--------------------'
p [1, 1].all?(1)
p [1, 1].my_all?(1)
p '----------------------array any?----------------------------'
p [nil, nil].any?
p [nil, nil].my_any?
p '----------------------array any? pattern--------------------'
p [1, 2, 3].any?(2)
p [1, 2, 3].my_any?(2)

p '----------------------array none false pattern--------------'
p words.none?('dog')
p words.my_none?('dog')

p '----------------------inject words length-------------------'
p words.inject(['']) { |a, w| [a + [w], [w], a][w.length <=> a.last.length] }
p words.my_inject(['']) { |a, w| [a + [w], [w], a][w.length <=> a.last.length] }

p '----------------------inject range--------------------------'
p(range.inject { |prod, n| prod * n })
p(range.my_inject { |prod, n| prod * n })
