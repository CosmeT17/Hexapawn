@tool
extends Node2D
class_name Grid

#region Constants and Variables
enum {NORTH, EAST, SOUTH, WEST, NORTH_EAST, SOUTH_EAST, SOUTH_WEST, NORTH_WEST}
const DROPZONE = preload("res://Board/Scenes/Dropzone.tscn") as PackedScene
const LABEL_BOARD_3X3_THEME = preload("res://Board/Themes/Label_Board_3x3_Theme.tres") as Theme
const LABEL_BOARD_4X4_THEME = preload("res://Board/Themes/Label_Board_4x4_Theme.tres") as Theme
const ID_pos_offset := Vector2(2,2)
var dropzones: Array[Array] 

#region Export Variables
#region Measurements Export Variables
@export_category("Measurements")
@export_enum("3x3:3", "4x4:4", "None: 0") var dimensions: int = 3 :
	set(dim):
		if dimensions != dim and dim in [3, 4, 0]:
			dimensions = dim
			initialize_grid()

@export_range(300, 700) var size: int = 636 :
	set(val):
		if size != val:
			if val < 300: size = 300
			elif val > 700: size = 700
			else: size = val
			organize_zones()
#endregion

#region Dropzones Export Variables
@export_category("Dropzones")
@export_range(0, 50) var area_offset: int = 0 :
	set(offset):
		if area_offset != offset:
			if offset < 0: area_offset = 0
			elif offset > 50: area_offset = 50
			else: area_offset = offset
			update_zone_offset()

@export var dropzone_color: Color = Color(Color.MEDIUM_SEA_GREEN, 0.25) :
	set(color):
		if dropzone_color != color:
			dropzone_color = color
			recolor_zones()

@export var show_dropzones: bool = true :
	set(val):
		if show_dropzones != val:
			show_dropzones = val
			update_zone_visibility()
#endregion

#region IDs Export Variables
@export_category("IDs")
@export var show_dropzone_ID: bool = true :
	set(val):
		if show_dropzone_ID != val:
			show_dropzone_ID = val
			update_dropzone_ID_visibility()

@export var dropzone_ID_centered: bool = true :
	set(val):
		if dropzone_ID_centered != val:
			dropzone_ID_centered = val
			update_dropzone_ID_position()
#endregion
#endregion
#endregion

func _ready():
	if dimensions == 3:
		initialize_grid()

func initialize_grid() -> void:
	generate_zones()
	organize_zones()
	recolor_zones()
	update_zone_visibility()
	update_dropzone_ID_visibility()
	update_dropzone_ID_position()

func generate_zones() -> void:
	dropzones = []
	for zone in get_children():
		if zone is Dropzone:
			zone.free()
	
	if dimensions != 0:
		var coordinates: Vector2 = Vector2.ZERO
		var ascii_start_val: int = 'A'.to_ascii_buffer()[0]
		var ascii_val: int = ascii_start_val
		var char_id_val: int = ascii_val
		
		for i: int in range(dimensions ** 2):
			var zone: Dropzone = DROPZONE.instantiate()
			
			zone.coordinates = coordinates
			zone.name = String.chr(ascii_val) + str(coordinates.y + 1)
			
			zone.char_ID = String.chr(char_id_val)
			char_id_val += 1
			
			if coordinates.x == 0: dropzones.append([])
			dropzones[coordinates.y].append(zone)
			
			zone.get_neighbor = func(direction: int): 
				return get_neighbor(zone, direction)
				
			if coordinates.x < dimensions - 1:
				coordinates.x += 1
				ascii_val += 1
			elif coordinates.y < dimensions - 1:
				coordinates.x = 0
				coordinates.y += 1
				ascii_val = ascii_start_val
			
			add_child(zone)
			
			#match dimensions:
				#Global.BOARD_3X3: zone.label_id.theme = LABEL_BOARD_3X3_THEME
				#Global.BOARD_4X4: zone.label_id.theme = LABEL_BOARD_4X4_THEME

func organize_zones() -> void:
	if dimensions != 0:
		var size_f: float = float(size) # Used to prevent integer devision
		var square_radius: float = size_f / dimensions / 2
		var zone_radius: int = floor(square_radius - area_offset)
		var start_position: Vector2 = Vector2(-(size_f/2) + square_radius, (size_f/2) - square_radius)
		var count: int = 0
		
		for zone in get_children():
			if zone is Dropzone:
				zone.radius = zone_radius
				zone.position = start_position + Vector2(2 * count * square_radius, 0)
				
				if not dropzone_ID_centered and zone.label_id:
					zone.label_id.position -= Vector2(area_offset, area_offset)
					zone.label_id.position += ID_pos_offset
				
				count += 1
				if count == dimensions:
					start_position = start_position + Vector2(0, -2 * square_radius)
					count = 0

func update_zone_offset() -> void:
	if dimensions != 0:
		var square_radius: float = float(size) / dimensions / 2
		var zone_radius: int = floor(square_radius - area_offset)
		
		for zone in get_children():
			if zone is Dropzone:
				if zone.radius != zone_radius:
					zone.radius = zone_radius
					
					if not dropzone_ID_centered and zone.label_id:
						zone.label_id.position -= Vector2(area_offset, area_offset)
						zone.label_id.position += ID_pos_offset

func recolor_zones() -> void:
	for zone in get_children():
		if zone is Dropzone:
			if zone.color != dropzone_color:
				zone.color = dropzone_color

func update_zone_visibility() -> void:
	if not Engine.is_editor_hint():
		Global.highlight_zone = not show_dropzones
	
	for zone in get_children():
		if zone is Dropzone:
			if zone.invisible != not show_dropzones:
				zone.invisible = not show_dropzones

func update_dropzone_ID_visibility() -> void:
	for zone in get_children():
		if zone is Dropzone:
			zone.show_ID = show_dropzone_ID

func update_dropzone_ID_position() -> void:
	for zone in get_children():
		if zone is Dropzone:
			if zone.ID_centered != dropzone_ID_centered:
				zone.ID_centered = dropzone_ID_centered
				
				if not dropzone_ID_centered and zone.label_id:
					zone.label_id.position -= Vector2(area_offset, area_offset)
					zone.label_id.position += ID_pos_offset

func get_neighbor(zone: Dropzone, direction: int) -> Dropzone:
	var coordinates: Vector2 = zone.coordinates
	
	match direction:
		NORTH: 
			if coordinates.y + 1 >= dimensions: return null
			return dropzones[coordinates.y + 1][coordinates.x]
		EAST:
			if coordinates.x + 1 >= dimensions: return null
			return dropzones[coordinates.y][coordinates.x + 1]
		SOUTH:
			if coordinates.y - 1 < 0: return null
			return dropzones[coordinates.y - 1][coordinates.x]
		WEST:
			if coordinates.x - 1 < 0: return null
			return dropzones[coordinates.y][coordinates.x - 1]
		NORTH_EAST:
			if coordinates.y + 1 >= dimensions or coordinates.x + 1 >= dimensions: return null
			return dropzones[coordinates.y + 1][coordinates.x + 1]
		SOUTH_EAST:
			if coordinates.y - 1 < 0 or coordinates.x + 1 >= dimensions: return null
			return dropzones[coordinates.y - 1][coordinates.x + 1]
		SOUTH_WEST:
			if coordinates.y - 1 < 0 or coordinates.x - 1 < 0 : return null
			return dropzones[coordinates.y - 1][coordinates.x - 1]
		NORTH_WEST:
			if coordinates.y + 1 >= dimensions or coordinates.x - 1 < 0: return null
			return dropzones[coordinates.y + 1][coordinates.x - 1]
			
	return null

func _to_string():
	var out: String = ""
	for row: int in range(dropzones.size()-1, -1, -1):
		out += "| "
		for column: int in range(dropzones[row].size()):
			out += str(dropzones[row][column])
			if column == dropzones[row].size() - 1: out += " |"
			else: out += " | "
		if row != 0: out += "\n"
	return out

func _on_tree_exiting():
	for zone: Dropzone in get_children():
		zone.free()
	if not Engine.is_editor_hint():
		Global.zones_destroyed.emit()
