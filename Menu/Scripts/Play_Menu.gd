class_name PlayMenu
extends MenuControl

signal start_3x3_board
signal start_4x4_board
signal exit_play_menu

func board_3x3_selected() -> void:
	start_3x3_board.emit()

func board_4x4_selected() -> void:
	start_4x4_board.emit()

func back_button_pressed() -> void:
	exit_play_menu.emit()
