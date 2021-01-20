#!/usr/bin/env ruby

require_relative '../enumerables'

ARRAY_SIZE = 100
LOWEST_VALUE = 0
HIGHEST_VALUE = 9

RSpec.describe 'enumerables' do
  let(:results_array) { [] }
  let(:my_results_array) { [] }
  let(:push_element) { proc { |element| results_array << element } }
  let(:my_push_element) { proc { |element| my_results_array << element } }
  let(:push_element_and_index) do
    proc do |element, index|
      results_array << element
      results_array << index
    end
  end
  let(:my_push_element_and_index) do
    proc do |element, index|
      my_results_array << element
      my_results_array << index
    end
  end
  let(:array) { Array.new(ARRAY_SIZE) { rand(LOWEST_VALUE...HIGHEST_VALUE) } }
  let(:block) { proc { |num| num < (LOWEST_VALUE + HIGHEST_VALUE) / 2 } }
  let(:empty_block) { proc {} }
  let(:range) { Range.new(5, 50) }
  let(:hash) { { a: 1, b: 2, c: 3, d: 4, e: 5 } }
  let(:words) { %w[dog door rod blade] }
  let(:expected) { 'dog' }
  let(:search) { proc { |memo, word| memo.length > word.length ? memo : word } }
  let(:false_array) { [nil, true, 99] }
  let(:true_array) { [1, 2i, 3.14] }
  let(:falsy_array) { [false, nil, false, false] }
  let(:transformation) { proc { |n| n**4 } }
  describe '#my_each' do
    it 'loops trough an array and push elements to a new array' do
      array.my_each(&my_push_element)
      array.each(&push_element)
      expect(my_results_array).to match_array(results_array)
    end
    it 'loops trough an range and push elements to a new array' do
      range.my_each(&my_push_element)
      range.each(&push_element)
      expect(my_results_array).to match_array(results_array)
    end
    it 'loops trough an hash and push elements to a new array' do
      hash.my_each(&my_push_element)
      hash.each(&push_element)
      expect(my_results_array).to match_array(results_array)
    end
    it 'returns Enumerator if no block given' do
      expect(array.my_each).to be_a(Enumerator)
    end
    it 'returns the array itself when a block is given' do
      expect(array.my_each(&empty_block)).to eq(array)
    end
    it 'returns the range itself when a block is given' do
      expect(range.my_each(&empty_block)).to eq(range)
    end
    it 'returns the hash itself when a block is given' do
      expect(hash.my_each(&empty_block)).to eq(hash)
    end
  end
  describe '#my_each_with_index' do
    it 'loops trough an array and push elements to a new array' do
      array.my_each(&my_push_element_and_index)
      array.each(&push_element_and_index)
      expect(my_results_array).to match_array(results_array)
    end
    it 'loops trough an range and push elements to a new array' do
      range.my_each(&my_push_element_and_index)
      range.each(&push_element_and_index)
      expect(my_results_array).to match_array(results_array)
    end
    it 'loops trough an hash and push elements to a new array' do
      hash.my_each(&my_push_element_and_index)
      hash.each(&push_element_and_index)
      expect(my_results_array).to match_array(results_array)
    end
    it 'returns Enumerator if no block given' do
      expect(array.my_each).to be_a(Enumerator)
    end
    it 'returns the array itself when a block is given' do
      expect(array.my_each(&empty_block)).to eq(array)
    end
    it 'returns the range itself when a block is given' do
      expect(range.my_each(&empty_block)).to eq(range)
    end
    it 'returns the hash itself when a block is given' do
      expect(hash.my_each(&empty_block)).to eq(hash)
    end
  end
  describe '#my_select' do
    it 'selects the item from the array' do
      favorites = words.my_select { |words| words == expected }
      expect(favorites).to eq([expected])
    end
    it 'returns Enumerator if no block given' do
      enumerator = array.my_select
      expect(enumerator).to be_a Enumerator
    end
  end
  describe '#my_all?' do
    it 'returns true with no block and no falsy elements' do
      expect(false_array.my_all?).not_to be(true)
      expect(true_array.my_all?).to be(true)
    end
    it 'returns true with class argument and all elements are members' do
      expect(array.my_all?(Integer)).to be(true)
      expect(true_array.my_all?(Integer)).not_to be(true)
    end
    it 'returns true when all elements match the regex' do
      expect(words.my_all?(/t/)).not_to be(true)
      expect(words.my_all?(/[aeiou]/)).to be(true)
    end
    it 'returns true when given a block all elements evaluate to true' do
      expect(words.my_all? { |word| word.length >= 3 }).to be(true)
      expect(words.my_all? { |word| word.length >= 4 }).not_to be(true)
    end
    it 'returns true when no argument or block given in an empty array' do
      expect(results_array.my_all?).to be(true)
    end
    it 'can handle case when no parameter, false or nil is given' do
      expect(true_array.my_all?).to be(true)
      expect(true_array.my_all?(nil)).not_to be(true)
      expect(true_array.my_all?(false)).not_to be(true)
      array.push(false)
      expect(true_array.my_all?).to be(true)
      expect(true_array.my_all?(nil)).not_to be(true)
      expect(true_array.my_all?(false)).not_to be(true)
      array.pop
      array.push(nil)
      expect(true_array.my_all?).to be(true)
      expect(true_array.my_all?(nil)).not_to be(true)
      expect(true_array.my_all?(false)).not_to be(true)
    end
  end
  describe '#my_any?' do
    it 'returns true with no block and at least one truthy elements' do
      expect(true_array.my_any?).to be(true)
      expect(falsy_array.my_any?).not_to be(true)
    end
    it 'returns true with class argument and any elements are members' do
      expect(array.my_any?(Integer)).to be(true)
      expect(falsy_array.my_any?(Integer)).not_to be(true)
    end
    it 'returns true when any elements match the regex' do
      expect(words.my_any?(/l/)).to be(true)
      expect(words.my_any?(/p/)).not_to be(true)
    end
    it 'returns true when given a block and any elements evaluate to true' do
      expect(words.my_any? { |word| word.length >= 4 }).to be(true)
      expect(words.my_any? { |word| word.length >= 6 }).not_to be(true)
    end
    it 'returns false when no argument or block given in an empty array' do
      expect(results_array.my_any?).to be(false)
    end
    it 'can handle case when no parameter, false or nil is given' do
      expect(array.my_any?).to be(true)
      expect(array.my_any?(nil)).to be(false)
      expect(array.my_any?(false)).to be(false)
      array.push(false)
      expect(array.my_any?).to be(true)
      expect(array.my_any?(nil)).to be(false)
      expect(array.my_any?(false)).to be(true)
      array.pop
      array.push(nil)
      expect(array.my_any?).to be(true)
      expect(array.my_any?(nil)).to be(true)
      expect(array.my_any?(false)).to be(false)
    end
  end
  describe '#my_none?' do
    it 'returns true with no block and no truthy elements' do
      expect(true_array.my_none?).to be(false)
      expect(falsy_array.my_none?).not_to be(false)
    end
    it 'returns true with class argument and no elements are members' do
      expect(array.my_none?(Integer)).to be(false)
      expect(falsy_array.my_none?(Integer)).not_to be(false)
    end
    it 'returns true when no elements match the regex' do
      expect(words.my_none?(/l/)).to be(false)
      expect(words.my_none?(/p/)).not_to be(false)
    end
    it 'returns true when given a block and no elements evaluate to true' do
      expect(words.my_none? { |word| word.length >= 4 }).to be(false)
      expect(words.my_none? { |word| word.length >= 6 }).not_to be(false)
    end
    it 'returns true when no argument or block given in an empty array' do
      expect(results_array.my_none?).to be(true)
    end
    it 'returns false when no block and nil or false argument' do
      expect(array.my_none?).to be(false)
    end
    it 'can handle case when no parameter, false or nil is given' do
      expect(array.my_none?).to be(false)
      expect(array.my_none?(nil)).to be(true)
      expect(array.my_none?(false)).to be(true)
      array.push(false)
      expect(array.my_none?).to be(false)
      expect(array.my_none?(nil)).to be(true)
      expect(array.my_none?(false)).to be(false)
      array.pop
      array.push(nil)
      expect(array.my_none?).to be(false)
      expect(array.my_none?(nil)).to be(false)
      expect(array.my_none?(false)).to be(true)
    end
  end
  describe '#my_count' do
    it 'counts the elements equal to the argument' do
      favorites = words.my_count(expected)
      expect(favorites).to eq(1)
    end
    it 'returns the number of items when no block or argument is given' do
      result = array.my_count
      expect(result).to eq(ARRAY_SIZE)
    end
    it 'counts the elements which yield true when block is given' do
      expect(array.my_count(&block)).to eq(array.count(&block))
    end
    it 'returns zero for the empty array' do
      expect(results_array.my_count).to eq(0)
    end
  end
  describe '#my_map' do
    it 'returns a transformed array of numbers when block is given' do
      result = array.my_map(&transformation)
      expected = array.map(&transformation)
      expect(result).to eq(expected)
    end
    it 'returns a transformed array of strings' do
      result = words.my_map { |w| "i like #{w}" }
      expected = words.map { |w| "i like #{w}" }
      expect(result).to eq(expected)
    end
    it 'returns Enumerator when no block is given' do
      result = array.map
      expect(result).to be_a Enumerator
    end
    it 'returns a transformed array of numbers when proc is given' do
      result = array.my_map(transformation)
      expected = array.map(&transformation)
      expect(result).to eq(expected)
    end
  end
  describe '#my_inject' do
    it 'reduces when block is given' do
      result = array.my_inject { |sum, n| sum + n }
      expected = array.reduce { |sum, n| sum + n }
      expect(result).to eq(expected)
    end
    it 'reduces a array when no block, no initial and symbol is given' do
      expect(array.my_inject(:+)).to eq(array.reduce(:+))
    end
    it 'reduces a range when no block, no initial and symbol is given' do
      expect(range.my_inject(:+)).to eq(range.reduce(:+))
    end
    it 'reduces a array when no block, initial and symbol is given' do
      expect(array.my_inject(100, :*)).to eq(array.reduce(100, :*))
    end
    it 'reduces a range when no block, initial and symbol is given' do
      expect(range.my_inject(100, :*)).to eq(range.reduce(100, :*))
    end
    it 'reduces a array when block and initial' do
      expect(array.my_inject(100) { |a, b| a << b }).to eq(array.reduce(100) { |a, b| a << b })
    end
    it 'reduces a range when block and initial' do
      expect(range.my_inject(100) { |a, b| a << b }).to eq(range.reduce(100) { |a, b| a << b })
    end
    it 'finds the longest word' do
      expect(words.my_inject(&search)).to eq(words.reduce(&search))
    end
    it 'raises a "LocalJumpError" when no block or argument is given' do
      expect { range.my_inject }.to raise_error(LocalJumpError)
    end
  end
  describe '#multiply_els' do
    it 'multiplies all the elements in the array unsing #my_inject' do
      correct = array.reduce { |product, n| product * n }
      expect(multiply_els(array)).to eq(correct)
    end
  end
end
