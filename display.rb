require "colorize"
require_relative "board"
require_relative "cursor"

class Display
  def initialize
    @board = Board.new
    @cursor = Cursor.new([0,0], @board)
  end

  def render
    puts "   a  b  c  d  e  f  g  h   "
    @board.rows.each_index do |row|
      print "#{8 - row} "
      @board.rows.each_index do |col|
        piece = @board[[row, col]]
        print color_piece(piece, [row, col])
      end
      print " #{8 - row}\n"
    end
    puts "   a  b  c  d  e  f  g  h   "
  end

  def color_piece(piece, pos)
    row, col = pos
    colored_piece = piece.symbol.to_s.colorize(piece.color).bold

    if [row, col] == @cursor.cursor_pos
      return " #{colored_piece} ".on_blue if @cursor.selected
      " #{colored_piece} ".on_light_blue
    elsif (row + col).even?
      " #{colored_piece} ".on_light_red
    else
      " #{colored_piece} ".on_red
    end
  end

  def cursor_test
    loop do
      system("clear")
      render
      @cursor.get_input
    end
  end
end
