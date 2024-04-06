extends Node2D

func _ready():
	var size: int = sqrt(get_children().size()) - 1
	var coordinates: Vector2 = Vector2.ZERO
	var ID: String = "A"
	
	for zone in get_children():
		zone.coordinates = coordinates
		zone.ID = ID
		
		if coordinates.x < size:
			coordinates.x += 1
		elif coordinates.y < size:
			coordinates.x = 0
			coordinates.y += 1
		
		ID = char(ID.to_ascii_buffer()[0] + 1)

# Prints information for testing purposes.
func _input(_event):
	if Input.is_action_just_pressed("Test"):
		var out: String = ""
		for zone in get_children():
			out = str(zone.get_name()) + ": "
			out += str(zone.coordinates) + "; "
			out += zone.ID + "; "
			if zone.pawn: out += zone.pawn.get_name()
			else: out += "NULL"
			print(out)
		print()
