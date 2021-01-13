require_relative "slideable_piece"

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
    if self[start_pos].nil?
      raise ArgumentError.new "There is no piece to move at #{start_pos}"
    elsif end_pos.any? { |x| !x.between?(0, 7) }
      raise ArgumentError.new "#{end_pos} is out of bounds"
    elsif self[end_pos] && self[start_pos].color == self[end_pos].color
      message = "#{start_pos} and #{end_pos} contain the same color pieces"
      raise ArgumentError.new message
    end

    self[end_pos], self[start_pos] = self[start_pos], nil
    self[end_pos].pos = end_pos
  end

  private

  def setup
    [0, 1].each do |row|
      (0..7).each { |col| rows[row] << Piece.new(:black, self, [row, col]) }
    end

    (2..5).each { |row| rows[row] = [nil] * 8 }

    [6, 7].each do |row|
      (0..7).each { |col| rows[row] << Piece.new(:white, self, [row, col]) }
    end
  end

end
