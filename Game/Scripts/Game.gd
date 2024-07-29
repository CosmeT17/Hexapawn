extends Node2D

const TEST = preload("res://Game/Scenes/Test.tscn") as PackedScene # TESTING
var start_board = Global.BOARD_3X3 as int

@onready var board_container = $Canvas/Board_Container as HBoxContainer

func _ready():
	# TESTING
	board_container.add_child(TEST.instantiate())
	#print_tree_pretty()
