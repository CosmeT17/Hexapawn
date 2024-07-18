@tool
extends Node2D
class_name Board

enum {BOARD_3X3 = 3, BOARD_4X4 = 4, NONE = 0}

const BOARD_3X3_TEXTURE = preload("res://Boards/Textures/Board/Board_3x3_Texture.png") as AtlasTexture
const BOARD_4X4_TEXTURE = preload("res://Boards/Textures/Board/Board_4x4_Texture.png") as AtlasTexture
const BOARD_DEFAULT_TEXTURE = preload("res://Boards/Textures/Board/Board_Default_Texture.png") as AtlasTexture

@onready var sprite = $Sprite as Sprite2D
@onready var grid = $Grid as Grid

@export_enum("3x3:3", "4x4:4", "None:0") var dimensions: int = 0 :
	set(dim):
		dimensions = dim
		if sprite:
			sprite.texture = BOARD_3X3_TEXTURE

#func update_texture() -> void:
	#match dimensions:
		#3: sprite.texture = BOARD_3X3_TEXTURE
		#4: sprite.texture = BOARD_4X4_TEXTURE
		#0: sprite.texture = BOARD_DEFAULT_TEXTURE
