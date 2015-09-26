require 'gosu'

require_relative 'player'

class SectorFive < Gosu::Window
  SCREEN_WIDTH = 800
  SCREEN_HEIGHT = 600

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT)
    self.caption = 'Sector Five'
    @player = Player.new(self)
  end

  def draw
    @player.draw
  end
end

window = SectorFive.new
window.show
