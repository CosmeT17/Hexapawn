class_name MenuControl
extends Node

func _ready():
	set_process(false)

func enter_menu() -> void:
	set_process(true)
	self.visible = true

func exit_menu() -> void:
	set_process(false)
	self.visible = false
