extends Player
class_name AI

@onready var Pawns = get_children()

# Hash table: Dictionary containing the best move per board state.
var moves = {}

func set_turn(val: bool):
	is_turn = val
	
	if is_turn and Entities.Grid:
		# New board state => store hash value of all possible legal moves.
		var BS: String = Entities.Grid.board_state
		if  BS not in moves:
			moves[BS] = []
			for pawn in Pawns:
				for zone in pawn.possible_moves():
					moves[BS].append([pawn, zone])
		
		# Checking for a stalemate ==> Player Wins.
		if moves[BS] == []:
			Entities.player.Game_Over()
		
		# TESTING
		print(BS + ': ' + str(moves[BS]) + '\n')

func update_score():
	Entities.Board.update_scores.emit("AI", num_wins)

func declare_winner():
	Entities.Board.toggle_border.emit("AI", "Winner")
