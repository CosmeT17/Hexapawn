@tool
extends Board
class_name Chessboard

const BOARD_3X3_TEXTURE = preload("res://Boards/Textures/Board/Board_3x3_Texture.png") as AtlasTexture
const BOARD_4X4_TEXTURE = preload("res://Boards/Textures/Board/Board_4x4_Texture.png") as AtlasTexture
const BOARD_DEFAULT_TEXTURE = preload("res://Boards/Textures/Board/Board_Default_Texture.png") as AtlasTexture

func _ready():
	set_textures([
		BOARD_3X3_TEXTURE,
		BOARD_4X4_TEXTURE,
		BOARD_DEFAULT_TEXTURE
	])
	super()
