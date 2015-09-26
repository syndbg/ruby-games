require 'gosu'

require_relative 'player'
require_relative 'enemy'
require_relative 'bullet'

class SectorFive < Gosu::Window
  SCREEN_WIDTH = 800
  SCREEN_HEIGHT = 600

  ENEMY_SPAWN_RATE = 0.02

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT)
    self.caption = 'Sector Five'
    @player = Player.new(self)

    @bullets = []
    @enemies = []
  end

  def draw
    @player.draw
    @enemies.map(&:draw)
    @bullets.map(&:draw)
  end

  def button_down(id)
    shoot_bullet if id == Gosu::KbSpace
  end

  def shoot_bullet
    @bullets.push(Bullet.new(self, @player.x, @player.y, @player.angle))
  end

  def update
    @player.turn_left if button_down? Gosu::KbLeft
    @player.turn_right if button_down? Gosu::KbRight
    @player.accelerate if button_down? Gosu::KbUp
    @player.move

    @enemies.push(Enemy.new(self)) if rand < ENEMY_SPAWN_RATE
    @enemies.map(&:move)

    @bullets.map(&:move)
  end
end

window = SectorFive.new
window.show
