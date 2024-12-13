class Grid
  def self.from_raw_input(input)
    grid = input.split.flat_map.with_index do |row, row_idx|
      row.chars.map.with_index do |char, col_idx|
        char_transform = yield(char) if block_given?
        [Position[row_idx, col_idx], char_transform || char]
      end
    end

    new(grid.to_h)
  end

  def initialize(grid) = @grid = grid

  Position = Data.define(:row, :col) do
    def +(other) = Position[row + other.row, col + other.col]
  end

  LABELED_DIRS = {
    up: Position[-1, 0], upleft: Position[-1, -1],
    left: Position[0, -1], upright: Position[-1, 1],
    right: Position[0, 1], downright: Position[1, 1],
    down: Position[1, 0], downleft: Position[1, -1]
  }

  CARDINALS = LABELED_DIRS.values_at(:up, :down, :left, :right)
  DIAGONALS = LABELED_DIRS.values_at(:upleft, :upright, :downleft, :downright)
  ALL_DIRECTIONS = LABELED_DIRS.values

  def adjacents_for_position(pos, adj_dirs: ALL_DIRECTIONS)
    adj_dirs.map { _1 + pos }.select(&@grid)
  end
end
