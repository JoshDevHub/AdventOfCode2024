class ClawMachine
  def initialize(a_deltas, b_deltas, prize_position)
    @a_deltas = a_deltas
    @b_deltas = b_deltas
    @prize_position = prize_position
  end

  UNIT_CONVERSION = 10_000_000_000_000
  A_BUTTON_TOKEN_COST = 3

  def convert! = @prize_position.map! { _1 + UNIT_CONVERSION }

  def solve
    ax, ay = @a_deltas
    bx, by = @b_deltas
    px, py = @prize_position

    a_presses = (py * bx - px * by) / (ay * bx - ax * by).to_f
    b_presses = (px - a_presses * ax) / bx.to_f

    return 0 if [a_presses, b_presses].any? { _1 != _1.to_i }

    (a_presses * A_BUTTON_TOKEN_COST + b_presses).to_i
  end
end

sections = ARGF.read.split("\n\n")

claw_machines = sections.map do |section|
  a_deltas, b_deltas, prize_pos = section.scan(/\d+/).map(&:to_i).each_slice(2).to_a
  ClawMachine.new(a_deltas, b_deltas, prize_pos)
end

p claw_machines.sum(&:solve)                  # p1
p claw_machines.each(&:convert!).sum(&:solve) # p2
