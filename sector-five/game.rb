require 'gosu'

require_relative 'player'
require_relative 'enemy'

class SectorFive < Gosu::Window
  SCREEN_WIDTH = 800
  SCREEN_HEIGHT = 600

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT)
    self.caption = 'Sector Five'
    @player = Player.new(self)

    @enemies = []
    spawn_enemies
  end

  def spawn_enemies
    3.times { @enemies.push(Enemy.new(self)) }
  end

  def draw
    @player.draw
    @enemies.map(&:draw)
  end

  def update
    @player.turn_left if button_down? Gosu::KbLeft
    @player.turn_right if button_down? Gosu::KbRight
    @player.accelerate if button_down? Gosu::KbUp
    @player.move

    @enemies.map(&:move)
  end
end

window = SectorFive.new
window.show
