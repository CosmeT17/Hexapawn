extends Node2D

@export var show_zone: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if show_zone:
		for pawn in get_children():
			pawn.show_zone = true
