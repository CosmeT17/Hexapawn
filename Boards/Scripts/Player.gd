@tool
extends Node
class_name Player

#region Constants and Variables
#region Constants
enum {WHITE, BLACK, UNTEXTURED}
enum {BLUE, RED}
#endregion

#region Variables
var player_num : int = -1 : 
	set(num):
		player_num = num
		
		if player_num > 0:
			match piece_color:
				WHITE: is_turn = true
				BLACK: is_turn = false

var is_turn: bool = true :
	set(val):
		if player_num != 0 and is_turn != val:
			if piece_color != UNTEXTURED:
				is_turn = val
				Global.turn_switched = true
				
				set_variable(
					func(piece: Piece): piece.can_move = is_turn,
					func(player: Player): player.is_turn = not is_turn
				)

var is_ready: bool = false
var alter_other_player: bool = true
#endregion

#region Export Variables
func set_variable(self_function: Callable, other_function) -> void:
	if is_ready:
		for piece in get_children():
			if piece is Piece:
				self_function.call(piece)
		
		if alter_other_player and other_function:
			for player in get_parent().get_children():
				if player is Player:
					if player != self:
						alter_other_player = false
						other_function.call(player)
		alter_other_player = true

#region Pieces Export Variables
@export_category("Pieces")
@export_enum("White", "Black", "Untextured") var piece_color: int = 2 :
	set(color):
		if player_num != 0 and piece_color != color:
			piece_color = color
			
			set_variable(
				func(piece: Piece): piece.piece_color = piece_color,
				func(player: Player):
					match piece_color:
						WHITE: player.piece_color = BLACK
						BLACK: player.piece_color = WHITE
						UNTEXTURED: player.piece_color = UNTEXTURED
			)
			
			if not Engine.is_editor_hint():
				if player_num == 1:
					match piece_color:
						WHITE: is_turn = true
						BLACK: is_turn = false

@export var highlight_dropzone: bool = true :
	set(val):
		if player_num != 0:
			highlight_dropzone = val
			# TODO

@export var show_piece_ID: bool = false :
	set(val):
		if player_num != 0 and show_piece_ID != val:
			show_piece_ID = val
			
			set_variable(
				func(piece: Piece): piece.show_ID = show_piece_ID,
				func(player: Player): player.show_piece_ID = show_piece_ID
			)
#endregion

#region AI Export Variables
@export_category("AI")
@export var is_ai: bool = false :
	set(val):
		if player_num == 2:
			is_ai = val
			
			set_variable(
				func(piece: Piece):
					if is_ai: piece.eye_color = RED
					else: piece.eye_color = BLUE,
				null
			)
		
		elif not is_ready and player_num == -1:
			is_ai = val

#TODO: More AI Settings
#endregion
#endregion
#endregion

# TODO:
# num_wins
# winning_y

func _ready():
	player_num = 0
	is_ready = true

func _on_child_entered_tree(node):
	if is_ready:
		if player_num != 0:
			if node is Piece:
				node.can_move = is_turn
				node.piece_color = piece_color
				node.show_ID = show_piece_ID
		else:
			node.queue_free()
