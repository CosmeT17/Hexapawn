extends Node2D

@export var grid_size: int = 0
@export var testing: bool = false

#@onready var board_sprite = get_parent
@onready var zones: Array = $Dropzones.get_children()

var board_state: String = "": get = get_board_state

func _ready():
	# Calculating grid size if not given.
	var size: int
	if grid_size == 0: size = int(sqrt(zones.size())) - 1
	else: size = grid_size - 1
	
	var coordinates: Vector2 = Vector2.ZERO
	var ID: String = "A"
	
	for zone in zones:
		zone.coordinates = coordinates
		zone.ID = ID
		
		if coordinates.x < size:
			coordinates.x += 1
		elif coordinates.y < size:
			coordinates.x = 0
			coordinates.y += 1
		
		ID = char(ID.to_ascii_buffer()[0] + 1)
	
	$Entities/Player.winning_y = size

func get_board_state() -> String:
	board_state = ""
	for pawn in get_tree().get_nodes_in_group("Pawn"):
		board_state += pawn.current_zone.ID
	return board_state

# Prints information for testing purposes.
func _input(_event):
	if testing and Input.is_action_just_pressed("Test"):
		print(board_state)
		var out: String = ""
		for zone in zones:
			out = str(zone.get_name()) + ": "
			out += str(zone.coordinates) + "; "
			out += zone.ID + "; "
			if zone.pawn: out += zone.pawn.get_name()
			else: out += "NULL"
			print(out)
		print()
