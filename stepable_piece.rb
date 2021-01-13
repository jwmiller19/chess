require_relative "piece"

module Stepable
  def moves
    row, col = pos
    all_moves = move_diffs.map do |row_inc, col_inc|
      [row + row_inc, col + col_inc]
    end

    all_moves.select { |move| in_bounds?(move) && !blocked?(move) }
  end

  def in_bounds?(move_pos)
    move_pos.all? { |x| x.between?(0, 7) }
  end

  def blocked?(move_pos)
    board[move_pos].color == color
  end
end

class Knight < Piece
  include Stepable

  def symbol
    :N
  end

  protected

  def move_diffs
    [ [-2, -1], [-2, 1], [-1, -2], [-1, 2], [2, -1], [2, 1], [1, -2], [1, 2] ]
  end
end

class King < Piece
  include Stepable

  def symbol
    :K
  end

  protected

  def move_diffs
    [ [0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1] ]
  end
end
