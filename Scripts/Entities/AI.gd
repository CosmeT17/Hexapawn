extends Player
class_name AI

# Stores the previously performed move
var move: Array

func set_turn(val: bool):
	super.set_turn(val)
	
	if is_turn:
		if moves[board_state]:
			move = moves[board_state].pick_random()
			print(move)
			
			move[0].update_zone(move[1])

func update_score():
	Entities.Board.update_scores.emit("AI", num_wins)

func declare_winner():
	Entities.Board.toggle_border.emit("AI", "Winner")
