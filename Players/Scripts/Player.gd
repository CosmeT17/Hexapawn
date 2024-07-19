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
			PLAYER_2: ['A3', 'B3', 'C3', 'D4']
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

@export_enum("3x3 Board:3", "4x4 Board:4", "None:0") var board_size = 0 as int :
	set(size):
		board_size = size
		generate_pieces()

@export_enum("Player 1:1", "Player 2:2") var player_num = 1 as int:
	set(num):
		player_num = num
		organize_default_pieces()
		#organize_pieces()

func _ready():
	Global.zones_loaded.connect(organize_pieces)
	generate_pieces()
	organize_default_pieces()

func generate_pieces() -> void:
	for piece in get_children():
		piece.free()
	
	for i: int in range(PIECE_TEAMS[board_size][PIECE_TYPES].size()):
		for j in range(PIECE_TEAMS[board_size][AMOUNT][i]):
			var piece: Piece = PIECE_TEAMS[board_size][PIECE_TYPES][i].instantiate()
			if board_size != Global.NONE: piece.piece_size = board_size
			add_child(piece)

func organize_default_pieces() -> void:
	if board_size == Global.NONE:
		for i: int in range(get_child_count()):
			get_children()[i].position = PIECE_TEAMS[Global.NONE][POSITIONS][player_num][i]

func organize_pieces() -> void:
	var zones: Array = get_tree().get_nodes_in_group("Zone")
	var j: int
	
	for i: int in range(get_child_count()):
		
		while j < zones.size():
			print(j)
			#print(i)
			#print(PIECE_TEAMS[board_size][POSITIONS][player_num][i])
			#print(j)
			j += 1
				
				
				#print(zones.size())
				#print(j)
				#if zones[j].ID == PIECE_TEAMS[board_size][POSITIONS][player_num][i]:
					#get_children()[i].global_position = zones[j].global_position
					#break
				#j += 1
		#else:
			#get_children()[i].position = PIECE_TEAMS[board_size][POSITIONS][player_num][i]
