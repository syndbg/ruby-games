require 'gosu'

require_relative 'bullet'
require_relative 'enemy'
require_relative 'explosion'
require_relative 'player'

class SectorFive < Gosu::Window
  SCREEN_WIDTH = 800
  SCREEN_HEIGHT = 600

  ENEMY_SPAWN_RATE = 0.02

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT)
    self.caption = 'Sector Five'
    @player = Player.new(self)

    @bullets = []
    @explosions = []
    @enemies = []
  end

  def draw
    @player.draw
    @enemies.map(&:draw)
    @bullets.map(&:draw)
    @explosions.map(&:draw)
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

    calculate_collisions

    clear_finished_explosions
    clear_offscreen_bullets
    clear_offscreen_enemies
  end

  def calculate_collisions
    calculate_enemy_bullets_collissions
    calculate_player_and_enemies_collissions
  end

  def calculate_player_and_enemies_collissions
    @enemies.each do |enemy|
      distance = Gosu.distance(@player.x, @player.y, enemy.x, enemy.y)
      next unless distance < @player.radius + enemy.radius
      @enemies.delete enemy
      @explosions.push Explosion.new(@player.x, @player.y)
      # TODO: Make it visual!
      puts 'RIP'
    end
  end

  def calculate_enemy_bullets_collissions
    @enemies.each do |enemy|
      @bullets.each do |bullet|
        distance = Gosu.distance(enemy.x, enemy.y, bullet.x, bullet.y)
        next unless distance < enemy.radius + bullet.radius
        register_enemy_bullets_collision(enemy, bullet)
      end
    end
  end

  def register_enemy_bullets_collision(enemy, bullet)
    @enemies.delete enemy
    @bullets.delete bullet
    @explosions.push Explosion.new(enemy.x, enemy.y)
  end

  def clear_finished_explosions
    @explosions.each do |explosion|
      @explosions.delete explosion if explosion.finished
    end
  end

  def clear_offscreen_bullets
    @bullets.each do |bullet|
      @bullets.delete bullet unless bullet.onscreen?
    end
  end

  def clear_offscreen_enemies
    @enemies.each do |enemy|
      @enemies.delete enemy unless enemy.onscreen?
    end
  end
end

window = SectorFive.new
window.show
