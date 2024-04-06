extends Node2D

var game_over: bool = false
var white_turn: bool = true

func _input(_event):
	if game_over and Input.is_action_just_pressed("New Game"):
		for pawn in get_tree().get_nodes_in_group("Pawn"):
			
			# Returning pawns back to initial positions for next game.
			pawn.current_zone = pawn.initial_zone
			pawn.global_position = pawn.current_zone.global_position
			
			# Reviving lost pawns.
			if not pawn.visible:
				pawn.visible = true
			
			# Starting new game.
			white_turn = true
			game_over = false
