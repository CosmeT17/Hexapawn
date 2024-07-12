@tool
extends Piece
#class_name Pawn

#region Constants
const PAWN_WHITE_BLUE_TEXTURE = preload("res://Pieces/Textures/Pawn/Pawn_White_Blue_Texture.png") as AtlasTexture
const PAWN_WHITE_RED_TEXTURE = preload("res://Pieces/Textures/Pawn/Pawn_White_Red_Texture.png") as AtlasTexture
const PAWN_BLACK_BLUE_TEXTURE = preload("res://Pieces/Textures/Pawn/Pawn_Black_Blue_Texture.png") as AtlasTexture
const PAWN_BLACK_RED_TEXTURE = preload("res://Pieces/Textures/Pawn/Pawn_Black_Red_Texture.png") as AtlasTexture
const PAWN_DEFAULT_TEXTURE = preload("res://Pieces/Textures/Pawn/Pawn_Default_Texture.png") as AtlasTexture
#endregion

func _ready():
	set_textures([
		PAWN_WHITE_BLUE_TEXTURE,
		PAWN_WHITE_RED_TEXTURE,
		PAWN_BLACK_BLUE_TEXTURE,
		PAWN_BLACK_RED_TEXTURE,
		PAWN_DEFAULT_TEXTURE
	])
	super()
