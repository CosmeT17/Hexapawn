class_name OptionsMenu
extends MenuControl

signal exit_options_menu

func back_button_pressed():
	exit_options_menu.emit()
