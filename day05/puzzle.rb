class Rules
  @rules_dict = {}
  def self.add(key, value) = @rules_dict[key] = (fetch(key) << value)
  def self.fetch(key) = @rules_dict.fetch(key, [])
end


class Update
  def initialize(sequence) = @sequence = sequence

  def valid?
    seen = Set.new
    @sequence.all? do |num|
      seen << num
      Rules.fetch(num).none? { seen.include? _1 }
    end
  end

  def midpoint = @sequence[@sequence.length / 2].to_i

  def sort!
    @sequence.sort! { |a, b| Rules.fetch(b).include?(a) ? 1 : 0 }
    self
  end
end


rules_input, updates_input = ARGF.read.split("\n\n").map(&:split)
rules_input.each { |input| Rules.add(*input.split("|")) }
update_list = updates_input.map { Update.new(_1.split(",")) }

p update_list.select(&:valid?).sum(&:midpoint)              # p1

p update_list.reject(&:valid?).map(&:sort!).sum(&:midpoint) # p2
