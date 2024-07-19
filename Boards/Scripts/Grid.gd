@tool
extends Node2D
class_name Grid

#region Constants and Variables
const DROPZONE = preload("res://Boards/Scenes/Dropzone.tscn") as PackedScene
const LABEL_OFFSETS: Dictionary = {
	3: Vector2(12, 10),
	4: Vector2(13, 9),
}

@export_category("Measurements")
@export_enum("3x3:3", "4x4:4", "None:0") var dimensions: int = 3 :
	set(dim):
		dimensions = dim
		generate_zones()
		organize_zones()

@export_range(300, 700) var size: int = 636 :
	set(val):
		size = val
		organize_zones()
	
@export_range(0, 50) var dropzone_offset: int = 6 :
	set(offset):
		dropzone_offset = offset
		update_zone_offset()
#endregion

func _ready():
	if self.get_children().is_empty():
		generate_zones()
		organize_zones()
		update_zone_offset()

func generate_zones() -> void:
	for zone in self.get_children():
		zone.free()
	
	if dimensions != 0:
		var coordinates: Vector2 = Vector2.ZERO
		var ascii_start_val: int = 'A'.to_ascii_buffer()[0]
		var ascii_val: int = ascii_start_val
		
		for i: int in range(dimensions ** 2):
			var zone: Dropzone = DROPZONE.instantiate()
			
			zone.coordinates = coordinates
			zone.name = String.chr(ascii_val) + str(coordinates.y + 1)
			
			if coordinates.x < dimensions - 1:
				coordinates.x += 1
				ascii_val += 1
			elif coordinates.y < dimensions - 1:
				coordinates.x = 0
				coordinates.y += 1
				ascii_val = ascii_start_val
			
			add_child(zone)

func organize_zones() -> void:
	if dimensions != 0:
		var size_f: float = float(size) # Used to prevent integer devision
		var square_radius: float = size_f / dimensions / 2
		var zone_radius: int = floor(square_radius - dropzone_offset)
		var start_position: Vector2 = Vector2(-(size_f/2) + square_radius, (size_f/2) - square_radius)
		var label_offset: Vector2 = Vector2(square_radius, square_radius) - LABEL_OFFSETS[dimensions]
		var count: int = 0
		
		for zone: Dropzone in get_children():
			zone.radius = zone_radius
			zone.position = start_position + Vector2(2 * count * square_radius, 0)
			if zone.label_id: zone.label_id.position -= label_offset
			
			count += 1
			if count == dimensions:
				start_position = start_position + Vector2(0, -2 * square_radius)
				count = 0
		
		if not Engine.is_editor_hint():
			if Global.zones_loaded:
				Global.zones_loaded.emit()

func update_zone_offset() -> void:
	if dimensions != 0:
		var square_radius: float = float(size) / dimensions / 2
		var zone_radius: int = floor(square_radius - dropzone_offset)
		
		for zone: Dropzone in get_children():
			zone.radius = zone_radius
