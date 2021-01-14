require_relative "piece"
require "singleton"

class NullPiece < Piece
  include Singleton

  attr_reader :color

  def initialize
    @color = nil
  end

  def symbol
    " "
  end

  def moves
    []
  end
end
