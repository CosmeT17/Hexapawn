@tool
extends Node
class_name Player

var player_num : int = 0

@export_category("Piece")
@export_enum("White", "Black", "Untextured") var piece_color = 2 as int :
	set(color):
		piece_color = color
		for piece in get_children():
			if piece is Piece:
				piece.piece_color = piece_color

#@export var is_AI: bool = false
#@export var is_turn: bool = false

# Pice:
# piece_color
# piece_eye_color
# show_piece_IDs

# Dropzones
# highlight_dropzones

# Internal
# move_direction
# winning_y
# num_wins

func _ready():
	pass

func _on_child_entered_tree(node):
	if node is Piece:
		node.piece_color = piece_color
