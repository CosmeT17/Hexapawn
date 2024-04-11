extends Node2D

const zone_scene = preload("res://Scenes/Objects/Dropzone.tscn")

func _ready():
	var pixel_size: float = get_parent().get_parent().texture.get_width()
	var grid_size: int
	
	#region Populate Grid
	grid_size = get_parent().grid_size
	var radius: int = int(pixel_size / grid_size / 2 - 6)
	
	for i in range(grid_size ** 2):
		var zone: Dropzone = zone_scene.instantiate()
		zone.name = "Zone_%d" % i
		zone.radius = radius
		add_child(zone)
	#endregion
	
	#region Organize Grid
	var increment: float = pixel_size / grid_size / 2
	
	var n: float = pixel_size - (pixel_size / 2)
	var start_position: Vector2 = Vector2(-n + increment, n - increment)
	
	var count: int = 0
	for zone in get_children():
		zone.position = start_position + Vector2(2 * count * increment, 0)
		count += 1
		
		if count == grid_size:
			count = 0
			start_position = start_position + Vector2(0, -2 * increment)
	#endregion
