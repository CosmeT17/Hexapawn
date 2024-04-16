extends Player
class_name AI

func set_turn(val: bool):
	super.set_turn(val)
	
	if is_turn:
		#print("AI Do Something")
		pass

func update_score():
	Entities.Board.update_scores.emit("AI", num_wins)

func declare_winner():
	Entities.Board.toggle_border.emit("AI", "Winner")
