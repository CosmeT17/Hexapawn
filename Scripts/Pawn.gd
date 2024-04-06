extends Node2D
class_name Pawn

@export var is_player: bool = true
@export var show_zone: bool = false


var direction: int = 1 # 1 -> UP, -1 -> DOWN
var range: int
var selected: bool = false

var dropzones: Array = []
var zone: Dropzone
var selected_zone: Dropzone
var previous_zone: Dropzone

func _ready():
	dropzones = get_tree().get_nodes_in_group("Zone")
	range = dropzones[0].radius
	#update_zone()
	
	# Assigning the initial zone.
	for zone in dropzones:
		if global_position.distance_to(zone.global_position) < range:
			self.zone = zone
			break
	self.zone.pawn = self
	
	# Changing the move direction to down if the pawn belongs to AI.
	if not is_player:
		direction = -1

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
	if Input.is_action_just_released("Click") and selected:
		selected = false
		update_zone()
		await get_tree().create_timer(0.15).timeout
		z_index = 0

# Returns the closest valid dropzone to the selected pawn.
func nearest_zone() -> Dropzone:
	for zone in dropzones:
		if global_position.distance_to(zone.global_position) < range and zone != self.zone:
			
			var diff_y: int = (zone.coordinates.y - self.zone.coordinates.y) * direction
			var diff_x: int = abs(zone.coordinates.x - self.zone.coordinates.x)
			
			print(diff_x)
			
			if diff_y == 1 and not zone.pawn:
				return zone
			
			#if not zone.pawn:
				#return zone
				
	return self.zone

# Moves the pawn to the selected valid zone. 
func update_zone():
	var zone: Dropzone = nearest_zone()
	
	if selected_zone: selected_zone.visible = false
	selected_zone = null
	previous_zone = null
	
	if self.zone != zone:
		self.zone.pawn = null
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
