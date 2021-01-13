require_relative "piece"

class Pawn < Piece
  def symbol
    :P
  end

  def moves
    all_moves = forward_steps + side_attacks
    all_moves.reject { |move| blocked?(move) }
  end

  private

  def at_start_row?
    color == :black ? pos[0] == 1 : pos[0] == 6
  end

  def forward_dir
    color == :black ? 1 : -1
  end

  def forward_steps
    row, col = pos
    steps = [ [row + forward_dir, col] ]
    second_step = [row + forward_dir * 2, col]
    forward_pieces = [ board[steps.first], board[second_step] ]

    if at_start_row? && forward_pieces.all? { |piece| piece.is_a?(NullPiece) }
      steps << second_step
    end

    steps.select { |move| in_bounds?(move) && board[move].is_a?(NullPiece) }
  end

  def side_attacks
    row, col = pos
    attacks = [ [row + forward_dir, col + 1], [row + forward_dir, col - 1] ]

    attacks.select { |move| in_bounds?(move) && !board[move].is_a?(NullPiece) }
  end

  def in_bounds?(move_pos)
    move_pos.all? { |x| x.between?(0, 7) }
  end

  def blocked?(move_pos)
    board[move_pos].color == color
  end
end
