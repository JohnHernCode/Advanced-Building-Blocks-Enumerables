#!/usr/bin/env ruby

require_relative '../enumerables'

ARRAY_SIZE = 100
LOWEST_VALUE = 0
HIGHEST_VALUE = 9

RSpec.describe 'enumerables' do
  let(:array) { Array.new(ARRAY_SIZE) { rand(LOWEST_VALUE...HIGHEST_VALUE) } }
  let(:block) { proc { |num| num < (LOWEST_VALUE + HIGHEST_VALUE) / 2 } }
  let(:words) { %w[dog door rod blade] }
  let(:range) { Range.new(5, 50) }
  let(:hash) { { a: 1, b: 2, c: 3, d: 4, e: 5 } }
  let(:numbers) { [1, 2i, 3.14] }
  let!(:array_clone) { array.clone }
  let(:search) { proc { |memo, word| memo.length > word.length ? memo : word } }
  let(:false_block) { proc { |num| num > HIGHEST_VALUE } }
  let(:true_array) { [1, 2i, 3.14] }
  let(:false_array) { [nil, true, 99] }
  it 'compare my_each to each with range' do
    expect(range.my_each(&block)).to eq(range.each(&block))
  end
end
