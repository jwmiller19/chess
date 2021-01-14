require_relative "board"
require_relative "display"
require_relative "player"

class Game
  attr_reader :board, :display, :players, :current_player

  def initialize
    @board = Board.new
    @display = Display.new(@board)

    white_player = HumanPlayer.new(:white, @display)
    black_player = HumanPlayer.new(:black, @display)

    @players = { white: white_player, black: black_player }
    @current_player = @players[:white]
  end

  def play
    until over?
      move = current_player.make_move
      correct_color?(move)
      board.move_piece(*move)
      swap_turn!
    end

    current_player.render
    notify_players
  rescue => e
    puts e
    sleep(2)
    retry
  end

  private

  def correct_color?(move)
    moved_color = board[move.first].color
    message = "That's not your color to move!"
    raise ArgumentError.new message unless moved_color == current_player.color
  end

  def over?
    board.checkmate?(:white) || board.checkmate?(:black)
  end

  def notify_players
    if board.checkmate?(:white)
      puts "Black has won!"
    elsif board.checkmate?(:black)
      puts "White has won!"
    end
  end

  def swap_turn!
    if current_player == players[:white]
      @current_player = players[:black]
    else
      @current_player = players[:white]
    end
  end
end
