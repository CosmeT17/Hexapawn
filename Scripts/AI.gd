extends Entity

func _ready():
	end_game.connect(AI_won)

func AI_won():
	print("AI Won")
	Game_Over()
