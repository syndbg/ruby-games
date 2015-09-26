require 'byebug'

class Player
  ACCELERATION = 1
  BOUNCE = 5
  FRICTION = 0.8
  TURN_RATE = 4

  def initialize(window)
    @image = Gosu::Image.new('images/ship.png')

    @x = 200
    @y = 200
    @angle = 0

    @velocity_x = 0
    @velocity_y = 0

    @radius = 20
    @window = window
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end

  def turn_left
    @angle -= TURN_RATE
  end

  def turn_right
    @angle += TURN_RATE
  end

  def accelerate
    @velocity_x += Gosu.offset_x(@angle, ACCELERATION)
    @velocity_y += Gosu.offset_y(@angle, ACCELERATION)
  end

  def move
    @x += @velocity_x
    @y += @velocity_y
    @velocity_x *= FRICTION
    @velocity_y *= FRICTION

    set_x_constraints
    set_y_constraints
  end

  def set_x_constraints
    if @x > @window.width - @radius
      @velocity_x = 0
      @x = @window.width - @radius - BOUNCE
    end

    if @x < @radius
      @velocity_x = 0
      @x = @radius + BOUNCE
    end
  end

  def set_y_constraints
    if @y > @window.height - @radius
      @velocity_y = 0
      @y = @window.height - @radius - BOUNCE
    end

    if @y < @radius
      @velocity_y = 0
      @y = @radius + BOUNCE
    end
  end
end
