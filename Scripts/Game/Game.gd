class_name Main
extends Node2D

enum {BOARD_3X3, BOARD_4X4}
var start_board = BOARD_3X3 as int
@onready var board = $Board as Node2D

var Board_3x3 = preload("res://Scenes/3x3/Board.tscn") as PackedScene
var Board_4x4 = preload("res://Scenes/4x4/Board.tscn") as PackedScene

signal update_cursor(context: int)

func _ready():
	match start_board:
		BOARD_3X3:
			board.add_child(Board_3x3.instantiate())
			
		BOARD_4X4:
			board.add_child(Board_4x4.instantiate())
