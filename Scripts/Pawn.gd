extends Node2D
class_name Pawn

@export var is_player: bool = true
@export var show_zone: bool = false
@export var movable: bool = true
@onready var entity = get_parent()

var direction: int = 1 # 1 -> UP, -1 -> DOWN
var range: int
var size: int

var selected: bool = false
var dropzones: Array = []

var zone: Dropzone
var initial_zone: Dropzone
var selected_zone: Dropzone
var previous_zone: Dropzone

func _ready():
	dropzones = get_tree().get_nodes_in_group("Zone")
	range = dropzones[0].radius
	
	# Assigning the initial zone.
	for zone in dropzones:
		if global_position.distance_to(zone.global_position) < range:
			self.zone = zone
			break
	self.zone.pawn = self
	initial_zone = self.zone
	
	# Changing the move direction to down if the pawn belongs to AI.
	if not is_player:
		direction = -1
		#movable = false

# Do the dragging.
func _physics_process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
		if show_zone: highlight_zone()
	else:
		global_position = lerp(global_position, zone.global_position, 10 * delta)

# Start dragging.
func _on_area_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("Click") and movable:
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
			
			# Move Forward
			if diff_y == 1:
				if diff_x == 0 and not zone.pawn:
					return zone
				
				# Move Diagonally.
				elif diff_x != 0 and zone.pawn:
					if get_groups()[1] != zone.pawn.get_groups()[1]:
						return zone
	return self.zone

# Updates the pawn's current zone to the selected zone. 
func update_zone():
	var zone: Dropzone = nearest_zone()
	
	# Hiding zone highlight.
	if selected_zone: selected_zone.visible = false
	selected_zone = null
	previous_zone = null
	
	# Updating the zones' pawn value.
	if self.zone != zone:
		
		# TODO: Properly kill pawns.
		if zone.pawn: zone.pawn.queue_free()
		
		self.zone.pawn = null
		self.zone = zone
		self.zone.pawn = self
	
	# TODO: Win/Lose
		if zone.coordinates.y == size:
			entity.end_game.emit()
			#if is_player: print("Player Won")
			#else: print("AI Won")

# Highlights the selected valid zone.
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
