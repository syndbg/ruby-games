class Bullet
  SPEED = 5

  attr_reader :x, :y, :radius, :shooter

  def initialize(window, x, y, angle, shooter)
    @shooter = shooter
    @image = Gosu::Image.new("images/#{shooter}_bullet.png")

    @window = window
    @x = x
    @y = y
    @angle = angle
    @radius = 3
  end

  def move
    case @shooter
    when :player
      @x += Gosu.offset_x(@angle, SPEED)
      @y += Gosu.offset_y(@angle, SPEED)
    when :enemy
      @x -= Gosu.offset_x(@angle, SPEED)
      @y -= Gosu.offset_y(@angle, SPEED)
    end
  end

  def draw
    @image.draw(@x - @radius, @y - @radius, 1)
  end

  def onscreen?
    left = -@radius
    right = @window.width + @radius
    top = -@radius
    bottom = @window.height + @radius

    @x > left && @x < right && @y > top && @y < bottom
  end
end
