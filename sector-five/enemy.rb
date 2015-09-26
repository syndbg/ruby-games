class Enemy
  SPEED = 4

  attr_reader :x, :y, :radius

  def initialize(window)
    @image = Gosu::Image.new('images/enemy.png')
    @window = window

    @radius = 20
    @x = rand(@window.width - 2 * @radius) + @radius
    @y = 0
  end

  def move
    @y += SPEED
  end

  def onscreen?
    @y < @window.height + @radius
  end

  def draw
    @image.draw(@x - @radius, @y - @radius, 1)
  end
end
