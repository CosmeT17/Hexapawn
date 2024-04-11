extends Node2D

const zone_scene = preload("res://Scenes/Objects/Dropzone.tscn")
@export var pre_populated: bool = true
@export var auto_organize: bool = false
@export var show_zones: bool = false

func _ready():
	var pixel_size: float = get_parent().get_parent().get_node("Sprite").texture.get_width()
	var grid_size: int
	
	#region Pre_Populated
	if not pre_populated and get_child_count() == 0:
		grid_size = get_parent().grid_size
		var radius: int = int(pixel_size / grid_size / 2 - 6)
		auto_organize = true
		
		for i in range(grid_size ** 2):
			var zone: Dropzone = zone_scene.instantiate()
			zone.name = "Zone_%d" % i
			zone.radius = radius
			add_child(zone)
	else:
		grid_size = int(sqrt(get_child_count()))
	#endregion
	
	#region Auto_Organize
	if auto_organize:
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
	
	#region Show_Zones
	if show_zones:
		for zone in get_children():
			zone.visible = true
	#endregion
