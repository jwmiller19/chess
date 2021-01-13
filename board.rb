require_relative "slideable_piece"
require_relative "stepable_piece"
require_relative "null_piece"
require_relative "pawn"

class Board
  attr_reader :rows

  def initialize
    @rows = Array.new(8) { [] }
    setup
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
    if self[start_pos].is_a?(NullPiece)
      raise ArgumentError.new "There is no piece to move at #{start_pos}"
    elsif end_pos.any? { |x| !x.between?(0, 7) }
      raise ArgumentError.new "#{end_pos} is out of bounds"
    elsif self[start_pos].color == self[end_pos].color
      message = "#{start_pos} and #{end_pos} contain the same color pieces"
      raise ArgumentError.new message
    end

    self[end_pos], self[start_pos] = self[start_pos], NullPiece.instance
    self[end_pos].pos = end_pos
  end

  private

  def setup
    rows[0] << Rook.new(:black, self, [0, 0])
    rows[0] << Knight.new(:black, self, [0, 1])
    rows[0] << Bishop.new(:black, self, [0, 2])
    rows[0] << Queen.new(:black, self, [0, 3])
    rows[0] << King.new(:black, self, [0, 4])
    rows[0] << Bishop.new(:black, self, [0, 5])
    rows[0] << Knight.new(:black, self, [0, 6])
    rows[0] << Rook.new(:black, self, [0, 7])

    (0..7).each { |col| rows[1] << Pawn.new(:black, self, [1, col]) }

    (2..5).each { |row| rows[row] = [NullPiece.instance] * 8 }

    (0..7).each { |col| rows[6] << Pawn.new(:white, self, [6, col]) }

    rows[7] << Rook.new(:white, self, [7, 0])
    rows[7] << Knight.new(:white, self, [7, 1])
    rows[7] << Bishop.new(:white, self, [7, 2])
    rows[7] << Queen.new(:white, self, [7, 3])
    rows[7] << King.new(:white, self, [7, 4])
    rows[7] << Bishop.new(:white, self, [7, 5])
    rows[7] << Knight.new(:white, self, [7, 6])
    rows[7] << Rook.new(:white, self, [7, 7])
  end

end
