extends Node2D

var range: int
var selected: bool = false
var dropzones: Array = []
var rest_point: Vector2

func _ready():
	dropzones = get_tree().get_nodes_in_group("Zone")
	range = dropzones[0].radius
	update_rest_point()
	position = rest_point

# Do the dragging.
func _physics_process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	else:
		global_position = lerp(global_position, rest_point, 10 * delta)

# Start dragging.
func _on_area_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("Click"):
		selected = true

# Stop dragging.
func _input(_event):
	if Input.is_action_just_released("Click"):
		update_rest_point()
		selected = false

# Find the closest dropzone.
func update_rest_point():
	for zone in dropzones:
		if global_position.distance_to(zone.global_position) < range:
			rest_point = zone.global_position
			break
