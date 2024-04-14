extends Node2D

@export_global_file("*.png") var labeled_board_texture = ""
@export var grid_size: int = 0
@export var testing: bool = false

@onready var board_texture = get_parent().texture
@onready var zones: Array = $Dropzones.get_children()

var board_state: String = ""

func _ready():
	var size = grid_size - 1
	var coordinates: Vector2 = Vector2.ZERO
	var ID: String = "A"
	
	# Initializing dropzones.
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
	
	# Updating texture for labeled board.
	if labeled_board_texture:
		labeled_board_texture = load(labeled_board_texture)
	
	# Showing testing elements.
	if testing: 
		toggle_grid_id()
		toggle_pawn_name()
	
	# Getting initial board state.
	update_board_state()

func update_board_state():
	board_state = ""
	for pawn in get_tree().get_nodes_in_group("Pawn"):
		if pawn.visible: board_state += pawn.current_zone.ID
		else: board_state += "_"

func toggle_grid_id():
	var parent = get_parent()
	if labeled_board_texture: 
		if parent.texture == board_texture: parent.texture = labeled_board_texture
		else: parent.texture = board_texture

func toggle_pawn_name():
	for pawn in get_tree().get_nodes_in_group("Pawn"):
		pawn.name_label.visible = not pawn.name_label.visible

# Prints information for testing purposes.
func _input(_event):
	if testing and Input.is_action_just_pressed("Test"):
		print(board_state)
		
		#var out: String = ""
		#for zone in zones:
			#out = str(zone.get_name()) + ": "
			#out += str(zone.coordinates) + "; "
			#out += zone.ID + "; "
			#if zone.pawn: out += zone.pawn.get_name()
			#else: out += "NULL"
			#print(out)
		#print()
