@tool
extends Board
class_name Chessboard

enum {PIECE_TYPES, AMOUNT, POSITIONS}

const PAWN = preload("res://Pieces/Scenes/Pawn.tscn") as PackedScene

const BOARD_3X3_TEXTURE = preload("res://Boards/Textures/Board/Board_3x3_Texture.png") as AtlasTexture
const BOARD_4X4_TEXTURE = preload("res://Boards/Textures/Board/Board_4x4_Texture.png") as AtlasTexture
const BOARD_DEFAULT_TEXTURE = preload("res://Boards/Textures/Board/Board_Default_Texture.png") as AtlasTexture

const PIECE_TEAMS: Dictionary = {
	Global.BOARD_3X3: {
		PIECE_TYPES: [PAWN],
		AMOUNT: [3],
		POSITIONS: {
			PLAYER_1: ['A1', 'B1', 'C1'],
			PLAYER_2: ['A3', 'B3', 'C3']
		}
	},
	Global.BOARD_4X4: {
		PIECE_TYPES: [PAWN],
		AMOUNT: [4],
		POSITIONS: {
			PLAYER_1: ['A1', 'B1', 'C1', 'D1'],
			PLAYER_2: ['A4', 'B4', 'C4', 'D4']
		}
	},
	Global.NONE:{
		PIECE_TYPES: [PAWN],
		AMOUNT: [3],
		POSITIONS: {
			PLAYER_1: [Vector2(-212, 200), Vector2(0, 200), Vector2(212, 200)],
			PLAYER_2: [Vector2(-212, -200), Vector2(0, -200), Vector2(212, -200)]
		}
	}
}

@onready var player_1 = $Player_1
@onready var player_2 = $Player_2

func _ready():
	set_textures([
		BOARD_3X3_TEXTURE,
		BOARD_4X4_TEXTURE,
		BOARD_DEFAULT_TEXTURE
	])
	super()
	
	generate_pieces(player_1)
	generate_pieces(player_2)
	#organizea_default_pieces(player_1, PLAYER_1)
	#organizea_default_pieces(player_2, PLAYER_2)
	organize_pieces(player_1, PLAYER_1)
	organize_pieces(player_2, PLAYER_2)

func generate_pieces(player: Node2D) -> void:
	for piece in player.get_children():
		piece.free()
	
	for i: int in range(PIECE_TEAMS[dimensions][PIECE_TYPES].size()):
		for j in range(PIECE_TEAMS[dimensions][AMOUNT][i]):
			var piece: Piece = PIECE_TEAMS[dimensions][PIECE_TYPES][i].instantiate()
			if dimensions != Global.NONE: piece.piece_size = dimensions
			player.add_child(piece)

func organizea_default_pieces(player: Node2D, player_num: int) -> void:
	if dimensions == 0:
		for i: int in range(player.get_child_count()):
			player.get_children()[i].position = PIECE_TEAMS[dimensions][POSITIONS][player_num][i]

func organize_pieces(player: Node2D, player_num: int) -> void:
	print("o")
	var zones: Array = get_tree().get_nodes_in_group("Zone")
	var j: int = 0
	
	for i: int in range(player.get_child_count()):
		if dimensions == Global.NONE:
			player.get_children()[i].position = PIECE_TEAMS[dimensions][POSITIONS][player_num][i]
		else:
			while j < zones.size():
				print(j)
				if zones[j].ID == PIECE_TEAMS[dimensions][POSITIONS][player_num][i]:
					player.get_children()[i].global_position = zones[j].global_position
					j += 1
					break
	
