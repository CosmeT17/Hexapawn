@tool
extends Piece
#class_name Pawn

#region Constants
const PAWN_WHITE_BLUE_TEXTURE = preload("res://Pieces/Textures/Pawn/Pawn_White_Blue_Texture.png") as AtlasTexture
const PAWN_WHITE_RED_TEXTURE = preload("res://Pieces/Textures/Pawn/Pawn_White_Red_Texture.png") as AtlasTexture
const PAWN_BLACK_BLUE_TEXTURE = preload("res://Pieces/Textures/Pawn/Pawn_Black_Blue_Texture.png") as AtlasTexture
const PAWN_BLACK_RED_TEXTURE = preload("res://Pieces/Textures/Pawn/Pawn_Black_Red_Texture.png") as AtlasTexture
#endregion

#func _enter_tree():

	#texture = piece_textures[[BLACK, RED]]

func _ready():
	super()
	
	piece_textures[[WHITE, BLUE]] = PAWN_WHITE_BLUE_TEXTURE
	piece_textures[[WHITE, RED]] = PAWN_WHITE_RED_TEXTURE
	piece_textures[[BLACK, BLUE]] = PAWN_BLACK_BLUE_TEXTURE
	piece_textures[[BLACK, RED]] = PAWN_BLACK_RED_TEXTURE
	
	texture = piece_textures[[piece_color, eye_color]]
	update_name_color()
