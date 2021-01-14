require_relative "display"

class HumanPlayer
  attr_reader :color, :display

  def initialize(color, display)
    @color = color
    @display = display
  end

  def make_move
    start_pos = get_pos
    end_pos = get_pos

    [start_pos, end_pos]
  end

  def render
    color_string = color.to_s.capitalize.bold.colorize(color)

    system("clear")
    puts "It is #{color_string}'s turn."
    display.render
  end

  private

  def get_pos
    render
    selected_pos = display.cursor.get_input

    until selected_pos
      render
      selected_pos = display.cursor.get_input
    end

    selected_pos
  end
end
