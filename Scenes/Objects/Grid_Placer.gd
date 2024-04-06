extends Node2D

@export var pre_populated: bool = true
@export var auto_organize: bool = false
@export var show_zones: bool = false

func _ready():
	var grid_size: int
	
	if not pre_populated:
		grid_size = get_parent().grid_size
	else:
		grid_size = int(sqrt(get_child_count()))
	
	if auto_organize:
		var pixel_size: float = get_parent().get_parent().get_node("Sprite").texture.get_width()
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
		
		
	
	if show_zones:
		for zone in get_children():
			zone.visible = true
