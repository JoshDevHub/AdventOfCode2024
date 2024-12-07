module ConcatableIntegers
  refine Integer do
    def concat(other) = "#{self}#{other}".to_i
  end
end

class Equation
  using ConcatableIntegers

  attr_reader :test_value
  attr_writer :operators
  def initialize(test_value, operands)
    @test_value = test_value
    @operands = operands
    @operators = %i[+ *]
  end

  def solvable?(operands = @operands, total = 0)
    return total == @test_value if operands.length.zero?

    curr_operand, *rest = operands
    @operators.any? { solvable?(rest, total.send(_1, curr_operand)) }
  end
end

equations = ARGF.readlines(chomp: true).map do |line|
  test_value_input, operands_input = line.split(": ")
  Equation.new(test_value_input.to_i, operands_input.split.map(&:to_i))
end

solvable_two_op_eqs, unsolvable_eqs = equations.partition(&:solvable?)
two_op_calibration = solvable_two_op_eqs.sum(&:test_value)

three_op_calibration = unsolvable_eqs
  .each { _1.operators = %i[* + concat] }
  .select(&:solvable?)
  .sum(&:test_value)
  .then { _1 + two_op_calibration }

p two_op_calibration   # p1
p three_op_calibration # p2
