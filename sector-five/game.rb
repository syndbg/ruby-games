require 'gosu'

require_relative 'bullet'
require_relative 'enemy'
require_relative 'explosion'
require_relative 'player'

class SectorFive < Gosu::Window
  SCREEN_WIDTH = 800
  SCREEN_HEIGHT = 600

  HIT_SCORE = 5
  DEATH_SCORE = 50

  ENEMY_SPAWN_RATE = 0.02
  ENEMY_SHOOT_RATE = 0.05

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT)
    @font = Gosu::Font.new(30)

    self.caption = 'Sector Five'
    @player = Player.new(self)

    @bullets = []
    @explosions = []
    @enemies = []

    @score = 0
  end

  def draw
    @player.draw
    @enemies.map(&:draw)
    @bullets.map(&:draw)
    @explosions.map(&:draw)

    draw_score
  end

  def draw_score
    @font.draw(@score.to_s, 700, 20, 2)
  end

  def button_down(id)
    player_shoot_bullet if id == Gosu::KbSpace
  end

  def player_shoot_bullet
    @bullets.push(Bullet.new(self, @player.x, @player.y, @player.angle, :player))
  end

  def update
    listen_to_player_movements

    @enemies.push(Enemy.new(self)) if rand < ENEMY_SPAWN_RATE
    enemy_shoot_bullet(@enemies.sample) if rand < ENEMY_SHOOT_RATE

    move_entities
    calculate_collisions
    clear_entities
  end

  def enemy_shoot_bullet(enemy)
    return if enemy.nil?
    @bullets.push(Bullet.new(self, enemy.x, enemy.y, 0, :enemy))
  end

  def move_entities
    @enemies.map(&:move)
    @bullets.map(&:move)
  end

  def listen_to_player_movements
    @player.turn_left if button_down? Gosu::KbLeft
    @player.turn_right if button_down? Gosu::KbRight
    @player.accelerate if button_down? Gosu::KbUp
    @player.move
  end

  def clear_entities
    clear_finished_explosions
    clear_offscreen_bullets
    clear_offscreen_enemies
  end

  def calculate_collisions
    calculate_enemy_and_bullets_collissions
    calculate_player_and_bullets_collissions
    calculate_enemy_and_explosions_collissions
    calculate_player_and_enemies_collissions
  end

  def calculate_player_and_enemies_collissions
    @enemies.each do |enemy|
      distance = Gosu.distance(@player.x, @player.y, enemy.x, enemy.y)
      next unless distance < @player.radius + enemy.radius
      register_player_and_enemies_collission(enemy)
    end
  end

  def register_player_and_enemies_collission(enemy)
    @enemies.delete enemy
    @explosions.push Explosion.new(@player.x, @player.y)
    @score -= DEATH_SCORE
  end

  def calculate_enemy_and_bullets_collissions
    @enemies.each do |enemy|
      @bullets.each do |bullet|
        next unless bullet.shooter == :player
        distance = Gosu.distance(enemy.x, enemy.y, bullet.x, bullet.y)
        next unless distance < enemy.radius + bullet.radius
        register_enemy_bullets_collision(enemy, bullet)
      end
    end
  end

  def calculate_player_and_bullets_collissions
    @bullets.each do |bullet|
      next unless bullet.shooter == :enemy
      distance = Gosu.distance(@player.x, @player.y, bullet.x, bullet.y)
      next unless distance < @player.radius + bullet.radius
      @bullets.delete bullet
      @explosions.push Explosion.new(@player.x, @player.y)
      @score -= DEATH_SCORE
    end
  end

  def calculate_enemy_and_explosions_collissions
    @enemies.each do |enemy|
      @explosions.each do |explosion|
        distance = Gosu.distance(enemy.x, enemy.y, explosion.x, explosion.y)
        next unless distance < enemy.radius + explosion.radius
        register_enemy_explosion_collission(enemy, explosion)
      end
    end
  end

  def register_enemy_explosion_collission(enemy, explosion)
    @enemies.delete enemy
    @explosions.delete explosion
    @explosions.push Explosion.new(enemy.x, enemy.y)
  end

  def register_enemy_bullets_collision(enemy, bullet)
    @enemies.delete enemy
    @bullets.delete bullet
    @explosions.push Explosion.new(enemy.x, enemy.y)

    @score += HIT_SCORE
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
