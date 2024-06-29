class_name OptionsMenu
extends Control

var main_menu

func on_back_pressed() -> void:
	get_tree().root.add_child(main_menu)
	get_tree().root.remove_child(self)
