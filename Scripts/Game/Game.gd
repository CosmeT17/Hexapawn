extends Node2D

@export_enum("3x3", "4x4") var starting_board = 0
@onready var Board = $Board

var Board_3x3 = preload("res://Scenes/3x3/Board.tscn").instantiate()
var Board_4x4 = preload("res://Scenes/4x4/Board.tscn").instantiate()

signal update_cursor(context: int)

func _ready():
	if starting_board == 0: Board.add_child(Board_3x3)
	else: Board.add_child(Board_4x4)
