extends Node2D

var selected: bool = false

func _on_area_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("Click"):
		selected = true

func _physics_process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			selected = false

func _on_area_area_exited(area):
	print(area)
