# frozen_string_literal: true

# This function is called on every turn of a game. It's how your Battlesnake decides where to move.
# Valid moves are "up", "down", "left", or "right".
# TODO: Use the information in board to decide your next move.
def move(game_state)
  directions = ["up", "down", "left", "right"]

  move_groups = directions.group_by do |move|
    pos = game_state.me.move(move)

    case
    when !game_state.board.valid?(pos)
      :invalid
    when game_state.board.occupied?(pos)
      :occupied
    when game_state.board.hazard?(pos)
      :hazard
    when game_state.board.food?(pos)
      :food
    else
      :safe
    end
  end

  possible_moves = move_groups[:food] || move_groups[:safe] || move_groups[:hazard] || move_groups[:occupied] || ["up"]

  move = possible_moves.sample
  puts "MOVE: " + move
  { "move": move }
end
