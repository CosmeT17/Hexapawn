extends Node2D
class_name Sex

const BOARD_3X_3_TEXTURE = preload("res://Boards/Textures/Board/Board_3x3_Texture.png")
const BOARD_4X_4_TEXTURE = preload("res://Boards/Textures/Board/Board_4x4_Texture.png")
const BOARD_DEFAULT_TEXTURE = preload("res://Boards/Textures/Board/Board_Default_Texture.png")

@onready var fuck_me = $"Fuck Me"


@export_enum("one", "two", "three") var milk = 0 as int :
	set(ass):
		milk = ass
		
		if (fuck_me):
			match ass:
				0: fuck_me.texture = BOARD_3X_3_TEXTURE
				1: fuck_me.texture = BOARD_4X_4_TEXTURE
				2: fuck_me.texture = BOARD_DEFAULT_TEXTURE
