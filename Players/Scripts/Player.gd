@tool
extends Node2D
class_name Player

enum {PIECE_TYPES, AMOUNT, POSITIONS}
enum {PLAYER_1 = 1, PLAYER_2 = 2}

const PAWN = preload("res://Pieces/Scenes/Pawn.tscn") as PackedScene

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

#@onready var parent: Board = get_parent()

@export_enum("Player 1:1", "Player 2:2") var player_num = 1 as int

func _ready():
	Global.zones_loaded.connect(organize_pieces)
	generate_pieces()
	organizea_default_pieces()

func generate_pieces() -> void:
	for piece in get_children():
		piece.free()
	
	var board_size: int = get_parent().dimensions
	
	for i: int in range(PIECE_TEAMS[board_size][PIECE_TYPES].size()):
		for j in range(PIECE_TEAMS[board_size][AMOUNT][i]):
			var piece: Piece = PIECE_TEAMS[board_size][PIECE_TYPES][i].instantiate()
			if board_size != Global.NONE: piece.piece_size = board_size
			add_child(piece)

func organizea_default_pieces() -> void:
	var board_size: int = get_parent().dimensions
	if board_size == 0:
		for i: int in range(get_child_count()):
			get_children()[i].position = PIECE_TEAMS[board_size][POSITIONS][player_num][i]

func organize_pieces() -> void:
	var zones: Array = get_tree().get_nodes_in_group("Zone")
	var board_size: int = get_parent().dimensions
	var j: int
	
	for i: int in range(get_child_count()):
		if board_size == Global.NONE:
			get_children()[i].position = PIECE_TEAMS[board_size][POSITIONS][player_num][i]
		else:
			while j < zones.size():
				if zones[j].ID == PIECE_TEAMS[board_size][POSITIONS][player_num][i]:
					get_children()[i].global_position = zones[j].global_position
					j += 1
					break
