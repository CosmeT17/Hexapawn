extends Node2D

@onready var AI = $AI
@onready var player = $Player
@onready var Board = get_parent().get_parent().get_parent()

var game_over: bool = false
var can_calculate_move = false

# Reset game.
func _input(_event):
	if game_over and Input.is_action_just_pressed("New Game"):
		# Resetting score pic borders.
		if AI.is_white: Board.toggle_border.emit("AI")
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
			AI.can_move = true
			player.can_move = true
			
			# Starting new game.
			AI.reset()
			player.reset()
			game_over = false

func turn_over(entity_name: String):
	if entity_name == "Player":
		Board.toggle_border.emit("AI")
		AI.is_turn = true
	else:
		Board.toggle_border.emit("Player")
		player.is_turn = true

# No one can move any pieces until a new game starts.
func Game_Over():
	Board.toggle_border.emit()
	AI.can_move = false
	player.can_move = false
