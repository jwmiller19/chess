require_relative "piece"

module Slideable
  # Includes horizontal AND veritcal directions
  def horizontal_dirs
    horizontal_moves = []

    HORIZONTAL_DIRS.each do |direction|
      row, col = pos
      path = direction.map { |row_inc, col_inc| [row + row_inc, col + col_inc] }

      path.each do |move|
        next unless in_bounds?(move) && !blocked?(move, path)
        horizontal_moves << move
      end
    end

    horizontal_moves
  end

  def diagonal_dirs
    diagonal_moves = []

    DIAGONAL_DIRS.each do |direction|
      row, col = pos
      path = direction.map { |row_inc, col_inc| [row + row_inc, col + col_inc] }

      path.each do |move|
        next unless in_bounds?(move) && !blocked?(move, path)
        diagonal_moves << move
      end
    end

    diagonal_moves
  end

  def in_bounds?(move_pos)
    move_pos.all? { |x| x.between?(0, 7) }
  end

  def blocked?(move_pos, path)
    move_index = path.index(move_pos)

    board[move_pos].color == color ||
      path[0...move_index].any? { |path_pos| !board[path_pos].is_a?(NullPiece) }
  end

  def moves
    all_moves = []

    all_moves += horizontal_dirs if move_dirs.include?(:horizontal)
    all_moves += diagonal_dirs if move_dirs.include?(:diagonal)

    all_moves
  end

  private

  # Includes horizontal AND veritcal directions
  HORIZONTAL_DIRS = [ [ [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0] ],
                      [ [-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0] ],
                      [ [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7] ],
                      [ [0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6], [0, -7] ]
                    ]
  DIAGONAL_DIRS = [ [ [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7] ],
                    [ [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7] ],
                    [ [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7] ],
                    [ [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7] ]
                  ]
end

class Bishop < Piece
  include Slideable

  def symbol
    :B
  end

  private

  def move_dirs
    [:diagonal]
  end
end

class Rook < Piece
  include Slideable

  def symbol
    :R
  end

  private

  def move_dirs
    [:horizontal]
  end
end

class Queen < Piece
  include Slideable

  def symbol
    :Q
  end

  private

  def move_dirs
    [:horizontal, :diagonal]
  end
end
