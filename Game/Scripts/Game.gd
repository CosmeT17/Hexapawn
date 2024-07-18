extends Node2D

const TEST = preload("res://Game/Scenes/Test.tscn") as PackedScene # TESTING
var start_board = Global.BOARD_3X3 as int

func _ready():
	# TESTING
	add_child(TEST.instantiate())
	#print_tree_pretty()
