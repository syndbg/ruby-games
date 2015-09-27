class Enemy
  MAX_SPEED = 6

  attr_reader :x, :y, :radius

  def initialize(window)
    @image = Gosu::Image.new('images/enemy.png')
    @window = window

    @speed = rand(1..MAX_SPEED)
    @radius = 20
    @x = rand(@window.width - 2 * @radius) + @radius
    @y = 0
  end

  def move
    @y += @speed
  end

  def onscreen?
    @y < @window.height + @radius
  end

  def draw
    @image.draw(@x - @radius, @y - @radius, 1)
  end
end
