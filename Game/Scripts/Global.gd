extends Node

# Zones
var show_zone:= false

# Pieces
var snap_speed:= 30 
var drag_speed:= 20
var zone_speed:= 10

func _input(_event):
	if Input.is_action_just_pressed("Test"):
		for zone: Dropzone in get_tree().get_nodes_in_group("Zone"):
			print(zone, ': ', zone.piece)
		print()
