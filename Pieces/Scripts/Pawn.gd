@tool
extends Piece
class_name Pawn

#region Constants
const PAWN_WHITE_BLUE_TEXTURE = preload("res://Pieces/Textures/Pawn/Pawn_White_Blue_Texture.png") as AtlasTexture
const PAWN_WHITE_RED_TEXTURE = preload("res://Pieces/Textures/Pawn/Pawn_White_Red_Texture.png") as AtlasTexture
const PAWN_BLACK_BLUE_TEXTURE = preload("res://Pieces/Textures/Pawn/Pawn_Black_Blue_Texture.png") as AtlasTexture
const PAWN_BLACK_RED_TEXTURE = preload("res://Pieces/Textures/Pawn/Pawn_Black_Red_Texture.png") as AtlasTexture
const PAWN_DEFAULT_TEXTURE = preload("res://Pieces/Textures/Pawn/Pawn_Default_Texture.png") as AtlasTexture
enum {UP = 1, DOWN = -1}
#endregion

var move_direction: int = DOWN

func _ready():
	set_textures([
		PAWN_WHITE_BLUE_TEXTURE,
		PAWN_WHITE_RED_TEXTURE,
		PAWN_BLACK_BLUE_TEXTURE,
		PAWN_BLACK_RED_TEXTURE,
		PAWN_DEFAULT_TEXTURE
	])
	letter_ID = 'P'
	super()

func assign_initial_zone() -> void:
	super()
	if initial_zone.coordinates.y == 0 or initial_zone.coordinates.y == 1: 
		move_direction = UP

func is_zone_valid(zone: Dropzone) -> bool:
	if not super(zone): return false
	
	match move_direction:
		UP: if get_neighbor.call(zone, Global.SOUTH) == current_zone: return true
		DOWN: if get_neighbor.call(zone, Global.NORTH) == current_zone: return true
	
	return false

# TODO - BUGS:
# Table dropzone IDs not positioned correctly.
# Mouse cursor changes incorrectly when a piece is dragged on top of another piece of the same color and is let go.
