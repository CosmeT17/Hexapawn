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
enum {HEXAPAWN, CHESS}
#endregion

var move_direction: int = DOWN
var end_of_board_y: int = 0
var mode: int = HEXAPAWN

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
		end_of_board_y = get_tree().get_nodes_in_group("Board")[0].dimensions - 1

func is_zone_valid(zone: Dropzone) -> bool:
	if not super(zone): return false
	
	if not zone.piece:
		match move_direction:
			UP: return is_neighbor.call(Global.SOUTH)
			DOWN: return is_neighbor.call(Global.NORTH)
	
	else:
		match move_direction:
			UP: if is_neighbor.call(Global.SOUTH_EAST) or is_neighbor.call(Global.SOUTH_WEST): 
				#print("capture")
				return true
			DOWN: if is_neighbor.call(Global.NORTH_EAST) or is_neighbor.call(Global.NORTH_WEST): 
				#print("capture")
				return true
	
	return false

func update_zone(zone: Dropzone = get_nearest_zone()) -> void:
	super(zone)
	
	if current_zone.coordinates.y == end_of_board_y:
		if mode == HEXAPAWN: 
			if not Global.game_over:
				Global.game_over = true
				player.score_counter.game_won = true
				player.score_counter.score += 1
		
		else: pass # TODO: Chess pawn promotion
