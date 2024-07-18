extends Node2D

enum {BOARD_3X3 = 3, BOARD_4X4 = 4}
const TEST = preload("res://Game/Scenes/Test.tscn") as PackedScene # TESTING
var start_board = BOARD_3X3 as int

func _ready():
	# TESTING
	add_child(TEST.instantiate())
	#print_tree_pretty()
