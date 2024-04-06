extends Node
class_name Entity

signal end_game
var game_over: bool = false

func Game_Over():
	# Change to get_tree().get_nodes_in_group("Player")
	for pawn in get_tree().get_nodes_in_group("Pawn"):
		pawn.movable = false
		
	game_over = true

func _input(_event):
	if game_over and Input.is_action_just_pressed("New Game"):
		for pawn in get_tree().get_nodes_in_group("Pawn"):
			
			# Returning pawns back to initial positions for next game.
			pawn.current_zone = pawn.initial_zone
			pawn.global_position = pawn.current_zone.global_position
			
			# Reviving lost pawns.
			if not pawn.visible:
				pawn.visible = true
			
			#if pawn.get_groups()[1] == "Player":
			pawn.movable = true
