require 'gosu'

class WhackARuby < Gosu::Window
  GAME_LENGTH = 100 # seconds
  HIT_SCORE = 5
  MISS_SCORE = 1

  SCREEN_WIDTH = 800
  SCREEN_HEIGHT = 600

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT)
    self.caption = 'Whack the Ruby!'

    @font = Gosu::Font.new(30)
    @image = Gosu::Image.new('ruby.png')
    @hammer_image = Gosu::Image.new('hammer.png')

    @x = 200
    @y = 200

    @width = 50
    @height = 43

    @velocity_x = 3
    @velocity_y = 3

    @visible = 0
    @hit = 0
    @score = 0

    @playing = true
    @start_time = 0
  end

  def update
    return unless @playing
    @x += @velocity_x
    @y += @velocity_y

    @visible -= 1
    @time_left = (GAME_LENGTH - ((Gosu.milliseconds - @start_time) / 1000))
    @playing = false if @time_left < 0

    @velocity_x *= -1 if end_of_x?
    @velocity_y *= -1 if end_of_y?

    @visible = 50 if @visible < -10 && rand < 0.01
  end

  def end_of_x?
    @x + @width / 2 > SCREEN_WIDTH || @x - @width / 2 < 0
  end

  def end_of_y?
    @y + @height / 2 > SCREEN_HEIGHT || @y - @height / 2 < 0
  end

  def button_down(id)
    if @playing && id == Gosu::MsLeft
      calculate_hit
    elsif id == Gosu::KbSpace
      start_game
    end
  end

  def calculate_hit
    if Gosu.distance(mouse_x, mouse_y, @x, @y) < 50 && @visible >= 0
      @hit = 1
      @score += HIT_SCORE
    else
      @hit = -1
      @score -= MISS_SCORE
    end
  end

  def start_game
    @playing = true
    @visible = -10
    @start_time = Gosu.milliseconds
    @score = 0
  end

  def draw
    @image.draw(@x - @width / 2, @y - @height / 2, 1) if @visible > 0
    @hammer_image.draw(mouse_x - 40, mouse_y - 10, 1)

    draw_background
    draw_time_left
    draw_score
    draw_game_over unless @playing
  end

  def draw_background
    color = case @hit
            when 0
              Gosu::Color::NONE
            when 1
              Gosu::Color::GREEN
            when -1
              Gosu::Color::RED
            end

    # reset hit after finding out the color
    @hit = 0
    draw_quad(0, 0, color, 800, 0, color, 800, 600, color, 0, 600, color)
  end

  def draw_time_left
    @font.draw(@time_left.to_s, 20, 20, 2)
  end

  def draw_score
    @font.draw(@score.to_s, 700, 20, 2)
  end

  def draw_game_over
    @font.draw('Game Over', 300, 300, 3)
    @font.draw('Press the Space Bar to Play Again', 175, 350, 3)
    @visible = 20
  end
end

window = WhackARuby.new
window.show
