#!/usr/bin/ruby

require 'gosu'

class Player
  attr_reader :x, :y

  def initialize(window, x, y, color)
    @window = window
    @x = x
    @y = y
    @width = 40
    @height = 40
    @speed = 5
    @color = color
  end

  def move_left
    @x -= @speed
  end

  def move_right
    @x += @speed
  end

  def move_up
    @y -= @speed
  end

  def move_down
    @y += @speed
  end

  def draw
    @window.draw_quad(@x, @y, @color, @x + @width, @y, @color, @x + @width, @y + @height, @color, @x, @y + @height, @color)
  end
end

class Monster
  def initialize(window, x, y)
    @window = window
    @x = x
    @y = y
    @width = 40
    @height = 40
    @speed = 2
    @color = Gosu::Color::RED
  end

  def move_towards(players)
    closest_player = players.min_by { |player| distance_to(player) }
    dx = closest_player.x - @x
    dy = closest_player.y - @y
    distance = Math.sqrt(dx * dx + dy * dy)
    if distance > 0
      @x += (dx / distance) * @speed
      @y += (dy / distance) * @speed
    end

    # Wobble randomly to avoid merging into one place
    @x += rand(-25..25)
    @y += rand(-25..25)
  end

  def distance_to(player)
    Math.sqrt((@x - player.x) ** 2 + (@y - player.y) ** 2)
  end

  def draw
    @window.draw_quad(@x, @y, @color, @x + @width, @y, @color, @x + @width, @y + @height, @color, @x, @y + @height, @color)
  end
end

class GameWindow < Gosu::Window
  WIDTH = 2560
  HEIGHT = 1600
  #WIDTH = 1920
  #HEIGHT = 1080

  def initialize
    super(WIDTH, HEIGHT)
    #self.caption = "Ruby Shooter"
    self.caption = "Tapty"
    reset_game
  end

  def reset_game
    @player1 = Player.new(self, 1960, 800, Gosu::Color::GREEN)
    @player2 = Player.new(self,  600, 800, Gosu::Color::YELLOW)
    #@player1 = Player.new(self, 100, 100, Gosu::Color::GREEN)
    #@player2 = Player.new(self, 700, 500, Gosu::Color::YELLOW)
    @players = [@player1, @player2]
    @monsters = Array.new(5) { Monster.new(self, rand(WIDTH), rand(HEIGHT)) }
  end

  def update
    if Gosu.button_down?(Gosu::KB_ESCAPE)
      close
    elsif Gosu.button_down?(Gosu::KB_F12)
      reset_game
    end

    # Player 1 controls (Arrow keys)
    @player1.move_left if Gosu.button_down?(Gosu::KB_LEFT)
    @player1.move_right if Gosu.button_down?(Gosu::KB_RIGHT)
    @player1.move_up if Gosu.button_down?(Gosu::KB_UP)
    @player1.move_down if Gosu.button_down?(Gosu::KB_DOWN)

    # Player 2 controls (WSAD keys)
    @player2.move_left if Gosu.button_down?(Gosu::KB_A)
    @player2.move_right if Gosu.button_down?(Gosu::KB_D)
    @player2.move_up if Gosu.button_down?(Gosu::KB_W)
    @player2.move_down if Gosu.button_down?(Gosu::KB_S)

    @monsters.each { |monster| monster.move_towards(@players) }
  end

  def draw
    @player1.draw
    @player2.draw
    @monsters.each { |monster| monster.draw }
  end
end

GameWindow.new.show

