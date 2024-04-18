extends Player
class_name AI

@export_range(-0.05, 1, 0.05) var delay: float = 0.5
var move: Array # Stores the previously performed move
var moved: bool = true

func _ready():
	super._ready()
	if delay < 0:
		moved = false

func set_turn(val: bool):
	super.set_turn(val)
	
	if is_turn and not Entities.game_over:
		moved = false
		
		if moves[board_state]:
			move = moves[board_state].pick_random()
			print(move)
			
			if delay >= 0:
				await get_tree().create_timer(delay).timeout
				move[0].update_zone(move[1])

func update_score():
	Entities.Board.update_scores.emit("AI", num_wins)

func declare_winner():
	Entities.Board.toggle_border.emit("AI", "Winner")

func _input(_event):
	if is_turn and delay < 0 and Input.is_action_just_pressed("Alt_Click"):
		move[0].update_zone(move[1])
