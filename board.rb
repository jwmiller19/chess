require_relative "piece"

class Board
  attr_reader :rows

  def initialize
    @rows = Board.setup
  end

  def [](pos)
    row, col = pos
    @rows[row][col]
  end

  def []=(pos, val)
    row, col = pos
    @rows[row][col] = val
  end

  def move_piece(start_pos, end_pos)
    if self[start_pos].nil?
      raise ArgumentError.new "There is no piece to move at #{start_pos}"
    elsif self[end_pos]
      raise ArgumentError.new "There is already a piece at #{end_pos}"
    end

    self[end_pos], self[start_pos] = self[start_pos], nil
    self[end_pos].pos = end_pos
  end

  private

  def self.setup
    grid = Array.new(8) { [] }

    [0, 1, 6, 7].each do |row|
      (0..7).each { |col| grid[row] << Piece.new([row, col]) }
    end

    (2..5).each { |row| grid[row] = [nil] * 8 }

    grid
  end

end
