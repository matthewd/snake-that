# frozen_string_literal: true

class GameState
  def self.parse(hash)
    snake_from = lambda do |sh|
      Snake.new(*sh.values_at(:id, :name, :health, :body, :latency, :shout, :squad))
    end

    snakes = hash[:board][:snakes].map(&snake_from)

    new(
      Game.new(*hash[:game].values_at(:id, :ruleset, :timeout)),
      hash[:turn].to_i,
      Board.new(
        *hash[:board].values_at(:height, :width, :food, :hazards),
        snakes
      ),
      snakes.detect { |s| s.id == hash[:you][:id] } ||
        snake_from.call(hash[:you])
    )
  end

  attr_reader :game, :turn, :board, :me

  def initialize(game, turn, board, me)
    @game = game
    @turn = turn
    @board = board
    @me = me
  end
end

class Game
  attr_reader :id, :ruleset, :timeout

  def initialize(id, ruleset, timeout)
    @id = id
    @ruleset = ruleset
    @timeout = timeout
  end
end

class Board
  attr_reader :height, :width, :food, :hazards, :snakes

  def initialize(height, width, food, hazards, snakes)
    @height = height
    @width = width
    @food = food
    @hazards = hazards
    @snakes = snakes
  end

  def valid?(pos)
    pos[:x] >= 0 && pos[:y] >= 0 && pos[:x] < width && pos[:y] < height
  end

  def occupied?(pos)
    snakes.any? do |snake|
      snake.body.include?(pos)
    end
  end

  def hazard?(pos)
    hazards.include?(pos)
  end

  def food?(pos)
    food.include?(pos)
  end
end

class Snake
  attr_reader :id, :name, :health, :body, :latency, :shout, :squad

  def initialize(id, name, health, body, latency, shout, squad)
    @id = id
    @name = name
    @health = health
    @body = body
    @latency = latency
    @shout = shout
    @squad = squad
  end

  def head
    body.first
  end

  def move(direction)
    case direction
    when "up"
      { x: head[:x], y: head[:y] + 1 }
    when "down"
      { x: head[:x], y: head[:y] - 1 }
    when "left"
      { x: head[:x] - 1, y: head[:y] }
    when "right"
      { x: head[:x] + 1, y: head[:y] }
    end
  end
end
