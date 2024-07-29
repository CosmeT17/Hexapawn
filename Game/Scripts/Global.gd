extends Node

# Enums
enum {BOARD_3X3 = 3, BOARD_4X4 = 4, NONE = 0}
enum {WHITE, BLACK, UNTEXTURED}
enum {UP = 1, DOWN = -1}
enum {BLUE, RED}

# Pieces
var snap_speed := 30 
var drag_speed := 20
var zone_speed := 10

#signal zones_loaded
var highlight_zone := false

func _input(_event):
	if Input.is_action_just_pressed("Test"):
		for zone: Dropzone in get_tree().get_nodes_in_group("Zone"):
			print(zone, ': ', zone.piece)
		print()
