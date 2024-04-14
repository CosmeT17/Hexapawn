extends Player
class_name AI

@onready var Pawns = get_children()

# Hash table: Dictionary containing the best move per board state.
var moves = {}

func set_turn(val: bool):
	is_turn = val
	
	#if is_turn:
		#print(Entities.can_calculate_move)
	
	#if is_turn and Entities.can_calculate_move:
		#print("Calculate")
	
	#Entities.can_calculate_move = false

func update_score():
	Entities.Board.update_scores.emit("AI", num_wins)

func declare_winner():
	Entities.Board.toggle_border.emit("AI", "Winner")

