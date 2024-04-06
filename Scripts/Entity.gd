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
		print("Yes")
