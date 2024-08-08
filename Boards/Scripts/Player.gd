@tool
extends Node
class_name Player

enum {WHITE, BLACK, UNTEXTURED}

var alter_other_player: bool = true
func set_variable(self_function: Callable, other_function: Callable) -> void:
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
@export_enum("White", "Black", "Untextured") var piece_color: int = 2 :
	set(color):
		if piece_color != color:
			if color == UNTEXTURED:
				everyone_can_move = true
				is_turn = true
			else: everyone_can_move = false
				
			piece_color = color
			#print(self, ": ", piece_color)
			
			if color == WHITE: is_turn = true
			elif color == BLACK: is_turn = false
			
			var self_function = func(piece: Piece): 
				piece.piece_color = piece_color
			
			var other_function = func(player: Player):
				match piece_color:
					WHITE: player.piece_color = BLACK
					BLACK: player.piece_color = WHITE
					UNTEXTURED: player.piece_color = UNTEXTURED
			
			set_variable(self_function, other_function)

@export var show_piece_ID: bool = false:
	set(val):
		if show_piece_ID != val:
			show_piece_ID = val
			#print(self, ": ", show_piece_ID)
			
			var self_function = func(piece: Piece): 
				piece.show_ID = show_piece_ID
			
			var other_function = func(player: Player):
				player.show_piece_ID = show_piece_ID
			
			set_variable(self_function, other_function)

var player_num : int = 0
var everyone_can_move: bool = true
var is_turn: bool = true:
	set(val):
		if is_turn != val:
			if piece_color != UNTEXTURED and not Global.is_selected:
				is_turn = val
				#print(self, ": ", is_turn)
				
				if player_num == 2:
					Global.turn_switched = true
				
				var self_function = func(piece: Piece):
					piece.can_move = is_turn
				
				var other_function = func(player: Player):
					if everyone_can_move: player.is_turn = true
					else: player.is_turn = not is_turn
				
				set_variable(self_function, other_function)

# Pice:
# piece_color <----
# show_piece_IDs <----

# Dropzones
# highlight_dropzones

# Internal
# move_direction
# winning_y
# num_wins

func _on_child_entered_tree(node):
	if node is Piece:
		node.can_move = is_turn
		node.piece_color = piece_color
		node.show_ID = show_piece_ID
