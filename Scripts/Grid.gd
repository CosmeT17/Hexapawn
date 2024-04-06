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

	# For Testing
	#for i in get_children():
		#print(i.get_name() + ":\nCoordinates: " + str(i.coordinates) + "\nID: " + i.ID + "\n")
