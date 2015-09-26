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
    @enemy =  Enemy.new(self)
  end

  def draw
    @player.draw
    @enemy.draw
  end

  def update
    @player.turn_left if button_down? Gosu::KbLeft
    @player.turn_right if button_down? Gosu::KbRight
    @player.accelerate if button_down? Gosu::KbUp
    @player.move

    @enemy.move
  end
end

window = SectorFive.new
window.show
