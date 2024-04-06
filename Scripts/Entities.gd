extends Node2D

@onready var AI = $AI
@onready var player = $Player

var game_over: bool = false
#var white_turn: bool = true

func _input(_event):
	if game_over and Input.is_action_just_pressed("New Game"):
		for pawn in get_tree().get_nodes_in_group("Pawn"):
			
			# Returning pawns back to initial positions for next game.
			pawn.current_zone = pawn.initial_zone
			pawn.global_position = pawn.current_zone.global_position
			
			# Reviving lost pawns.
			if not pawn.visible:
				pawn.visible = true
			
			# Player and AI can now move pieces again.
			AI.can_move = true
			player.can_move = true
			
			# Starting new game.
			game_over = false

# No one can move any pieces until a new game starts.
func Game_Over():
	AI.can_move = false
	player.can_move = false
