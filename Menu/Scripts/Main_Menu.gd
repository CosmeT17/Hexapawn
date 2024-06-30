class_name MainMenu
extends MenuControl

signal enter_play_menu
signal enter_options_menu

func play_button_pressed() -> void:
	enter_play_menu.emit()

func options_button_pressed() -> void:
	enter_options_menu.emit()

func exit_button_pressed() -> void:
	get_tree().quit()
