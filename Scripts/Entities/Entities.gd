extends Node2D

@onready var AI_Controller = $AI
@onready var Player_Controller = $Player
@onready var Grid = get_parent()
@onready var Board = get_parent().get_parent().get_parent()
@onready var Cursor = get_tree().get_root().get_node("Game/Cursor")

var game_over: bool = false

# Reset game.
func _input(_event):
	if game_over and Input.is_action_just_pressed("Alt_Click"):
		# Resetting score pic borders.
		if AI_Controller.is_white: Board.toggle_border.emit("AI")
		else: Board.toggle_border.emit("Player")
		Board.toggle_border.emit("", "Winner")
		
		# Resetting pawns.
		for pawn in get_tree().get_nodes_in_group("Pawn"):
			# Returning pawns back to initial positions for next game.
			pawn.current_zone = pawn.initial_zone
			pawn.global_position = pawn.current_zone.global_position
			
			# Reviving lost pawns.
			if not pawn.visible:
				pawn.visible = true
			
			# Player and AI can now move pawns again.
			AI_Controller.can_move = true
			Player_Controller.can_move = true
			
		# Starting new game.
		Grid.update_board_state()
		AI_Controller.reset()
		Player_Controller.reset()
		game_over = false

func turn_over(entity_name: String):
	if entity_name == "Player":
		Board.toggle_border.emit("AI")
		AI_Controller.is_turn = true
	else:
		Board.toggle_border.emit("Player")
		Player_Controller.is_turn = true

# No one can move any pieces until a new game starts.
func Game_Over():
	Board.toggle_border.emit()
	AI_Controller.can_move = false
	Player_Controller.can_move = false
	game_over = true
