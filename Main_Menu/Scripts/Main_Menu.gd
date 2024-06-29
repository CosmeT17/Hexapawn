class_name MainMenu
extends Control

@onready var play_menu = preload("res://Main_Menu/Scenes/Play_Menu.tscn").instantiate() as PlayMenu

func _ready():
	play_menu.main_menu = self as MainMenu

func on_play_pressed() -> void:
	get_tree().root.add_child(play_menu)
	get_tree().root.remove_child(self)

func on_options_pressed() -> void:
	pass

func on_exit_pressed() -> void:
	get_tree().quit()
