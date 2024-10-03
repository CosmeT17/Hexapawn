@tool
extends Piece
class_name Pawn

#region Constants and Variables
const PAWN_WHITE_BLUE_TEXTURE = preload("res://Pieces/Textures/Pawn/Pawn_White_Blue_Texture.png") as AtlasTexture
const PAWN_WHITE_RED_TEXTURE = preload("res://Pieces/Textures/Pawn/Pawn_White_Red_Texture.png") as AtlasTexture
const PAWN_BLACK_BLUE_TEXTURE = preload("res://Pieces/Textures/Pawn/Pawn_Black_Blue_Texture.png") as AtlasTexture
const PAWN_BLACK_RED_TEXTURE = preload("res://Pieces/Textures/Pawn/Pawn_Black_Red_Texture.png") as AtlasTexture
const PAWN_DEFAULT_TEXTURE = preload("res://Pieces/Textures/Pawn/Pawn_Default_Texture.png") as AtlasTexture

enum {UP = 1, DOWN = -1}
enum {HEXAPAWN, CHESS}

var move_direction: int = DOWN
var end_of_board_y: int = 0
var mode: int = HEXAPAWN
#endregion

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

#var is_neighbor: Callable	
func is_zone_valid(zone: Dropzone) -> bool:
	if not super(zone): return false
	
	var target_coordinates = current_zone.coordinates + Vector2(0, move_direction)
	if not zone.piece: 
		if zone.coordinates == target_coordinates: return true
	else:
		if zone.coordinates == target_coordinates + Vector2(-1, 0): return true
		if zone.coordinates == target_coordinates + Vector2(1, 0): return true 
	
	return false

func update_zone(zone: Dropzone = get_nearest_zone()) -> void:
	super(zone)
	
	if current_zone.coordinates.y == end_of_board_y:
		#region Hexapawn: Check Win Condition -> Reach End of Board
		if mode == HEXAPAWN: 
			if not Global.game_over:
				player.game_won()
		#endregion
		
		else: pass # TODO: Chess pawn promotion

func get_moves() -> Array[Dropzone]:
	var moves: Array[Dropzone] = []
	var zones: Array[Dropzone]
	
	if current_zone:
		if move_direction == UP:
			zones = [
				current_zone.get_neighbor.call(Global.NORTH),
				current_zone.get_neighbor.call(Global.NORTH_WEST),
				current_zone.get_neighbor.call(Global.NORTH_EAST)
			]
		else:
			zones = [
				current_zone.get_neighbor.call(Global.SOUTH),
				current_zone.get_neighbor.call(Global.SOUTH_WEST),
				current_zone.get_neighbor.call(Global.SOUTH_EAST)
			]
		
		for i: int in range(zones.size()):
			if zones[i]:
				if zones[i].piece:
					if i != 0 and zones[i].piece.piece_color != self.piece_color:
						moves.append(zones[i])
				elif i == 0:
					moves.append(zones[i])
	
	return moves
