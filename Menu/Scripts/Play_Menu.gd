class_name PlayMenu
extends Control

@onready var game = preload("res://Main.tscn").instantiate() as Main
var main_menu
var options_menu

func start_game(board_type: int) -> void:
	main_menu.free()
	options_menu.free()
	
	game.start_board = board_type
	get_tree().root.add_child(game)
	get_tree().root.remove_child(self)
	self.queue_free()
	
func board_3x3_selected() -> void:
	start_game(game.BOARD_3X3)

func board_4x4_selected() -> void:
	start_game(game.BOARD_4X4)

func on_back_pressed() -> void:
	get_tree().root.add_child(main_menu)
	get_tree().root.remove_child(self)
