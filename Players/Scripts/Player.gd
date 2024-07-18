@tool
extends Node2D
class_name Player

#region Variables and Constants
enum {PLAYER_1, PLAYER_2}

const PAWN = preload("res://Pieces/Scenes/Pawn.tscn") as PackedScene

const PIECE_TEAMS: Dictionary = {
	Global.BOARD_3X3: {
		"Piece_Types": [PAWN],
		"Piece_Amount": [3],
		"Piece_Locations": {
			PLAYER_1: ['A1', 'B1', 'C1'],
			PLAYER_2: ['A3', 'B3', 'C3']
		}
	},
	Global.BOARD_4X4: {
		"Piece_Types": [PAWN],
		"Piece_Amount": [4],
		"Piece_Locations": {
			PLAYER_1: ['A1', 'B1', 'C1', 'D1'],
			PLAYER_2: ['A3', 'B3', 'C3', 'D3']
		}
	},
	Global.NONE: {
		"Piece_Types": [PAWN],
	}
}

@export_enum("Player 1", "Player 2") var player_number = 0 as int:
	set(num):
		player_number = num

@export_enum("3x3 Board:3", "4x4 Board:4", "None:0") var board_size = 0 as int :
	set(size):
		board_size = size
		generate_pieces()

@export_enum("White", "Black") var piece_color = 0 as int :
	set(color):
		piece_color = color

@export_enum("Blue", "Red") var eye_color = 0 as int :
	set(color):
		eye_color = color
#endregion

func _ready():
	pass

func generate_pieces() -> void:
	for piece in self.get_children():
		piece.free()
	
	for i: int in range(PIECE_TEAMS[board_size]["Piece_Types"].size()):
		for j in range(PIECE_TEAMS[board_size]["Piece_Amount"][i]):
			var piece: Piece = PIECE_TEAMS[board_size]["Piece_Types"][i].instantiate()
			piece.name = piece.name.substr(0, 2) + str(j + 1)
			add_child(piece)

	for piece: Piece in get_children():
		print(piece)
