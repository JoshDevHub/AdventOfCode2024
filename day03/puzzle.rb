class CorruptedMemory
  def initialize(raw_memory)
    @raw_memory = raw_memory
  end

  CAPTURE_DO_DONT = /(do)\(\)|(don't)\(\)/

  def raw_instructions = InstructionSequence.new(@raw_memory)

  def filtered_instructions
    enabled = true
    filtered_set = @raw_memory.split(CAPTURE_DO_DONT).select do |group|
      enabled = group == "do" and next if group in "do" | "don't"

      enabled
    end

    InstructionSequence.new(filtered_set.join)
  end
end

class InstructionSequence
  def initialize(instructions)
    @instructions = instructions
  end

  CAPTURE_MULTIPLY_OPERANDS = /mul\((\d+),(\d+)\)/

  def sum_multiply_operations
    @instructions.scan(CAPTURE_MULTIPLY_OPERANDS).sum do |instruction|
      instruction.map(&:to_i).reduce(:*)
    end
  end
end

memory = CorruptedMemory.new(ARGF.read.strip)

p memory.raw_instructions.sum_multiply_operations      # p1

p memory.filtered_instructions.sum_multiply_operations # p2
