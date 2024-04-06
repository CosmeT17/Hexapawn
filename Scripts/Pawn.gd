extends Node2D
class_name Pawn

var range: int
var selected: bool = false
var show_zone: bool = false
var dropzones: Array = []
var zone: Dropzone
var selected_zone: Dropzone
var previous_zone: Dropzone

func _ready():
	dropzones = get_tree().get_nodes_in_group("Zone")
	range = dropzones[0].radius
	update_zone()

# Do the dragging.
func _physics_process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
		if show_zone: highlight_zone()
	else:
		global_position = lerp(global_position, zone.global_position, 10 * delta)

# Start dragging.
func _on_area_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("Click"):
		z_index = 1
		selected = true

# Stop dragging.
func _input(_event):
	if Input.is_action_just_released("Click"):
		z_index = 0
		selected = false
		update_zone()

# Returns the closest valid dropzone to the selected pawn.
func nearest_zone() -> Dropzone:
	for zone in dropzones:
		if global_position.distance_to(zone.global_position) < range:
			if not zone.pawn:
				return zone
	return self.zone

# Moves the pawn to the selected valid zone. 
func update_zone():
	var zone: Dropzone = nearest_zone()
	
	if selected_zone: selected_zone.visible = false
	selected_zone = null
	previous_zone = null
	
	if not zone.pawn:
		if self.zone: self.zone.pawn = null
		self.zone = zone
		self.zone.pawn = self

func highlight_zone():
	var zone: Dropzone = nearest_zone()
	
	# Finding the selected and previously selected zones.
	if zone != self.zone:
		if zone != selected_zone:
			previous_zone = selected_zone
		selected_zone = zone
	
	# Making the selected zone visible and the previous zone invisible.
	if selected_zone and not selected_zone.visible: 
		selected_zone.visible = true
	if previous_zone and previous_zone: 
		previous_zone.visible = false
	
	# Making the previously selected zone invisible when no valid zone is selected.
	if zone == self.zone and selected_zone and selected_zone.visible:
		selected_zone.visible = false
