extends Player
class_name AI

@export var is_second_player: bool = false
@export_range(-0.05, 1, 0.05) var delay: float = 0.5
var move: Array # Stores the previously performed move

func set_turn(val: bool):
	super.set_turn(val)
	
	if not is_second_player:
		if is_turn and moves[board_state]:
			move = moves[board_state].pick_random()
			print(str(move))

			if delay >= 0:
				await get_tree().create_timer(delay).timeout
				move[0].update_zone(move[1])

func update_score():
	Entities.Board.update_scores.emit("AI", num_wins)

func declare_winner():
	Entities.Board.toggle_border.emit("AI", "Winner")

# Manual delay activation.
func _input(_event):
	if not is_second_player:
		if delay < 0 and is_turn and Input.is_action_just_pressed("Alt_Click"):
			move[0].update_zone(move[1])
