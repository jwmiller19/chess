require_relative "slideable_piece"
require_relative "stepable_piece"
require_relative "null_piece"
require_relative "pawn"

class Board
  attr_reader :rows

  def initialize
    @rows = Array.new(8) { [] }
    @null_piece = NullPiece.instance
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

  def dup
    new_board = Board.new

    @rows.each_index do |row|
      @rows.each_index do |col|
        pos = [row, col]
        piece = self[pos]

        if piece.is_a?(NullPiece)
          new_board.add_piece(@null_piece, pos)
        else
          new_piece = piece.class.new(piece.color, new_board, pos)
          new_board.add_piece(new_piece, pos)
        end
      end
    end

    new_board
  end

  def add_piece(piece, pos)
    self[pos] = piece
  end

  def move_piece!(start_pos, end_pos)
    if self[start_pos].is_a?(NullPiece)
      raise ArgumentError.new "There is no piece to move at #{start_pos}"
    elsif !valid_pos?(end_pos)
      raise ArgumentError.new "#{end_pos} is out of bounds"
    elsif self[start_pos].color == self[end_pos].color
      message = "#{start_pos} and #{end_pos} contain the same color pieces"
      raise ArgumentError.new message
    end

    self[end_pos], self[start_pos] = self[start_pos], @null_piece
    self[end_pos].pos = end_pos
  end

  def move_piece(start_pos, end_pos)
    if self[start_pos].is_a?(NullPiece)
      raise ArgumentError.new "There is no piece to move at #{start_pos}"
    elsif !valid_pos?(end_pos)
      raise ArgumentError.new "#{end_pos} is out of bounds"
    elsif self[start_pos].color == self[end_pos].color
      message = "#{start_pos} and #{end_pos} contain the same color pieces"
      raise ArgumentError.new message
    end

    message = "That's not a valid move!"
    raise message unless self[start_pos].valid_moves.include?(end_pos)

    self[end_pos], self[start_pos] = self[start_pos], @null_piece
    self[end_pos].pos = end_pos
  end

  def valid_pos?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end

  def in_check?(color)
    own_king_pos = find_king(color)

    rows.each do |row|
      row.each do |piece|
        next unless piece.color && piece.color != color

        return true if piece.moves.include?(own_king_pos)
      end
    end

    false
  end

  def find_king(color)
    rows.each do |row|
      row.each do |piece|
        return piece.pos if piece.is_a?(King) && piece.color == color
      end
    end
  end

  def checkmate?(color)
    return false unless in_check?(color)

    rows.each do |row|
      row.each do |piece|
        return false if piece.color == color && !piece.valid_moves.empty?
      end
    end

    true
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

    (2..5).each { |row| rows[row] = [@null_piece] * 8 }

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
