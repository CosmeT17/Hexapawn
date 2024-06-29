class_name MainMenu
extends Control

@onready var play_menu = preload("res://Menu/Scenes/Play_Menu.tscn").instantiate() as PlayMenu
@onready var options_menu = preload("res://Menu/Scenes/Options_Menu.tscn").instantiate() as OptionsMenu

func _ready():
	play_menu.main_menu = self as MainMenu
	options_menu.main_menu = self as MainMenu
	play_menu.options_menu = options_menu as OptionsMenu

func on_play_pressed() -> void:
	get_tree().root.add_child(play_menu)
	get_tree().root.remove_child(self)

func on_options_pressed() -> void:
	get_tree().root.add_child(options_menu)
	get_tree().root.remove_child(self)

func on_exit_pressed() -> void:
	get_tree().quit()
