extends Entity

@export var show_zone: bool = false

func _ready():
	end_game.connect(player_won)
	
	if show_zone:
		for pawn in get_children():
			pawn.show_zone = true

func player_won():
	print("Player Won")
	Game_Over()
