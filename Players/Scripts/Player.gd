@tool
extends Node
class_name Player

enum {WHITE, BLACK, UNTEXTURED}

var player_num : int = 0

var alter_other_player: bool = true
func perform_action(self_function: Callable, other_function: Callable) -> void:
	for piece in get_children():
		if piece is Piece:
			self_function.call(piece)
	
	if alter_other_player:
		for player in get_parent().get_children():
			if player is Player:
				if player != self and player.player_num != 0:
					alter_other_player = false
					other_function.call(player)
	alter_other_player = true


@export_category("Pieces")
@export_enum("White", "Black", "Untextured") var piece_color = 2 as int :
	set(color):
		piece_color = color
		
		var self_function = func(piece: Piece): 
			piece.piece_color = piece_color
		
		var other_function = func(player: Player):
			match piece_color:
				WHITE: player.piece_color = BLACK
				BLACK: player.piece_color = WHITE
				UNTEXTURED: player.piece_color = UNTEXTURED
		
		perform_action(self_function, other_function)

@export var show_piece_ID = false as bool :
	set(val):
		show_piece_ID = val
		#for piece in get_children():
			#if piece is Piece:
				#piece.show_ID = show_piece_ID

#@export var is_AI: bool = false
#@export var is_turn: bool = false

# Pice:
# piece_color <----
# show_piece_IDs <----

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
		node.show_ID = show_piece_ID
