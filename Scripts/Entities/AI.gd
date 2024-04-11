extends Player

func update_score():
	Game.update_scores.emit("AI", num_wins)
