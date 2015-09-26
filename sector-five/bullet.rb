class Bullet
  SPEED = 5

  def initialize(window, x, y, angle)
    @image = Gosu::Image.new('images/bullet.png')

    @window = window
    @x = x
    @y = y
    @angle = angle
    @radius = 3
  end

  def move
    @x += Gosu.offset_x(@angle, SPEED)
    @y += Gosu.offset_y(@angle, SPEED)
  end

  def draw
    @image.draw(@x - @radius, @y - @radius, 1)
  end
end
