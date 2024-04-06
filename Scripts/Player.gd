extends Node2D

@export var show_zone: bool = false

func _ready():
	if show_zone:
		for pawn in get_children():
			pawn.show_zone = true
