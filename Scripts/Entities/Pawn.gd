extends Node2D
class_name Pawn

@export var is_AI: bool = false
@export var is_white: bool = true

@onready var entity = get_parent()
@onready var name_label = $Sprite/Name

var direction: int = 1 # 1 -> UP, -1 -> DOWN
var zone_range: int

var movable: bool = true
var selected: bool = false

var dropzones: Array = []
var current_zone: Dropzone: set = set_zone
var initial_zone: Dropzone
var selected_zone: Dropzone
var previous_zone: Dropzone

func _ready():
	# Updating the name label with the pawns name.
	name_label.text = name
	
	dropzones = get_tree().get_nodes_in_group("Zone")
	zone_range = dropzones[0].radius
	
	# Assigning the initial zone.
	for zone in dropzones:
		if global_position.distance_to(zone.global_position) < zone_range:
			initial_zone = zone
			global_position = zone.global_position
			break
	current_zone = initial_zone
	
	# Changing the move direction to down if the pawn belongs to AI.
	if is_AI:
		direction = -1
		movable = false

# Do the dragging.
func _physics_process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
		if entity.show_zone: highlight_zone()
		
	elif global_position != current_zone.global_position:
		global_position = lerp(global_position, current_zone.global_position, 10 * delta)
			
		# Smooth-over movement
		if round(abs((global_position - current_zone.global_position))) == Vector2.ZERO:
			global_position = current_zone.global_position

# Start dragging.
func _on_area_input_event(_viewport, _event, _shape_idx):
	if movable and Input.is_action_just_pressed("Click") and entity.can_move and entity.is_turn:
		z_index = 1
		selected = true
#
# Stop dragging.
func _input(_event):
	if Input.is_action_just_released("Click") and selected:
		selected = false
		update_zone()
		await get_tree().create_timer(0.15).timeout # Prevent clipping
		z_index = 0

# Returns the closest valid dropzone to the selected pawn.
func nearest_zone() -> Dropzone:
	for zone in dropzones:
		if global_position.distance_to(zone.global_position) < zone_range and zone != current_zone:
			if is_zone_valid(zone):
				return zone
	return current_zone

# Updates the pawn's current zone to the selected zone. 
func update_zone(zone: Dropzone = nearest_zone()):
	# Hiding zone highlight.
	if entity.show_zone:
		if selected_zone: selected_zone.visible = false
		selected_zone = null
		previous_zone = null
	
	# Update the current zone only if it is not the current zone already.
	if current_zone != zone:
		# Pawn killer. (RIP)
		var game_won: bool = false
		if zone.pawn: 
			if zone.pawn.capture() == 0: game_won = true
		
		# Updating zone pawn values & declaring turn over.
		current_zone = zone
		
		# Checking win conditions.
		if game_won or current_zone.coordinates.y == entity.winning_y:
			entity.Game_Over()
		
		# Turn over
		else:
			entity.turn_over()

# Highlights the selected valid zone.
func highlight_zone():
	var zone: Dropzone = nearest_zone()
	
	# Finding the selected and previously selected zones.
	if zone != current_zone:
		if zone != selected_zone:
			previous_zone = selected_zone
		selected_zone = zone
	
	# Making the selected zone visible and the previous zone invisible.
	if selected_zone and not selected_zone.visible: 
		selected_zone.visible = true
	if previous_zone and previous_zone: 
		previous_zone.visible = false
	
	# Making the previously selected zone invisible when no valid zone is selected.
	if zone == current_zone and selected_zone and selected_zone.visible:
		selected_zone.visible = false

# Returns true if the pawn can legally move to the given zone, otherwise false.
func is_zone_valid(zone: Dropzone) -> bool:
	var diff_y: int = int((zone.coordinates.y - current_zone.coordinates.y) * direction)
	var diff_x: int = abs(zone.coordinates.x - current_zone.coordinates.x)
	
	# Check Forward
	if diff_y == 1:
		if diff_x == 0 and not zone.pawn:
			return true
		
		# Check Diagonally.
		elif diff_x != 0 and zone.pawn:
			if get_groups()[1] != zone.pawn.get_groups()[1]:
				return true
	return false

# Set zone to the current_zone and update the zone pawn values.
func set_zone(zone: Dropzone):
	if current_zone and current_zone.pawn == self: 
		current_zone.pawn = null
	current_zone = zone
	current_zone.pawn = self

# Capture this pawn ==> DEAD
func capture() -> int:
	visible = false
	entity.available_pawns -= 1
	return entity.available_pawns

# TODO: Make better by adding adjacency list to zone
# Returns a list of zones representing the possible moves.
func possible_moves() -> Array:
	var moves: Array = []
	
	# Getting coordinates of the nearest zones.
	var down: Vector2 = current_zone.coordinates + Vector2(0, direction)
	var left: Vector2 = down + Vector2(-1, 0)
	var right: Vector2 = down + Vector2(1, 0)
	
	# Finding the zones and appending them to the Array if they are valid.
	for zone in dropzones:
		if zone.coordinates == down or zone.coordinates == left or zone.coordinates == right:
			if is_zone_valid(zone):
				moves.append(zone)
	
	return moves

# str() Override
func _to_string():
	return "" + name
