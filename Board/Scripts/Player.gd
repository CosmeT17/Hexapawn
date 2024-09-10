@tool
extends Node
class_name Player

#region Constants and Variables
#region Constants
enum {WHITE, BLACK, UNTEXTURED}
enum {BLUE, RED}
#endregion

#region Variables
var player_num : int = -1
var is_ready: bool = false
var alter_other_player: bool = true

var is_turn: bool = true :
	set(val):
		if player_num != 0 and is_turn != val:
			if not (not Engine.is_editor_hint() and piece_color == UNTEXTURED):
				is_turn = val
				
				if not Engine.is_editor_hint(): 
					Global.turn_switched = true
				
				set_variable(
					func(piece: Piece): piece.can_move = is_turn if piece_color != UNTEXTURED else true,
					func(player: Player): player.is_turn = not is_turn if piece_color != UNTEXTURED else true
				)
#endregion

#region Export Variables
func set_variable(self_function: Callable, other_function, pre_run: bool = false) -> void:
	if is_ready or pre_run:
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
			if color == UNTEXTURED and is_ai: is_ai = false 
			piece_color = color
			
			set_variable(
				func(piece: Piece): piece.piece_color = piece_color,
				func(player: Player):
					match piece_color:
						WHITE: player.piece_color = BLACK
						BLACK: player.piece_color = WHITE
						UNTEXTURED: player.piece_color = UNTEXTURED
			)
			
			if piece_color == BLACK: is_turn = false
			else: is_turn = true

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
		if (player_num == 2 and piece_color != UNTEXTURED and is_ai != val) or not is_ready:
			is_ai = val
			
			set_variable(
				func(piece: Piece):
					if is_ai: 
						piece.eye_color = RED
						piece.highlight_zone = false
					else: 
						piece.eye_color = BLUE
						piece.highlight_zone = true,
				null,
				true
			)

#TODO: More AI Settings
#endregion
#endregion
#endregion

# TODO:
# num_wins
# winning_y

func _ready():
	player_num = 0
	is_ai = is_ai
	is_ready = true

func _on_child_entered_tree(node):
	if is_ready:
		if player_num != 0:
			if node is Piece:
				node.piece_color = piece_color
				node.show_ID = show_piece_ID
				node.piece_size = get_parent().get_parent().dimensions
				if piece_color == BLACK: node.can_move = false
				if is_ai: node.eye_color = RED
		else:
			node.queue_free()

func _to_string():
	const colors = {0: "WHITE", 1: "BLACK", 2: "UNTEXTURED"}
	const ai = {true: "IS_AI", false: "NOT_AI"}
	const turn = {true: "IS_TURN", false: "NOT_TURN"}
	
	var player_info: Array[String] = [
		colors[piece_color],
		ai[is_ai],
		turn[is_turn]
	]
	
	return str(name) + ": " + str(player_info)
