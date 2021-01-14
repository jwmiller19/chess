class Piece
  attr_reader :color, :board
  attr_accessor :pos

  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos
  end

  def valid_moves
    moves.reject { |move| move_into_check?(move) }
  end

  private

  def move_into_check?(end_pos)
    test_board = board.dup
    test_board.move_piece!(pos, end_pos)

    test_board.in_check?(color)
  end
end
