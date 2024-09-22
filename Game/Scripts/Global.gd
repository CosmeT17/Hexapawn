extends Node

#region Enums
enum {NORTH, EAST, SOUTH, WEST, NORTH_EAST, SOUTH_EAST, SOUTH_WEST, NORTH_WEST}
enum {BOARD_3X3 = 3, BOARD_4X4 = 4, NONE = 0}
enum {WHITE, BLACK, UNTEXTURED}
enum {BLUE, RED}
#endregion

#region Pieces
var num_pieces_mouse_on_area: int = 0 :
	set(num):
		num_pieces_mouse_on_area = num
		if num < 0: num_pieces_mouse_on_area = 0
		elif num > 2: num_pieces_mouse_on_area = 2

var avilable_moves: Dictionary = {}
var is_selected := false
var snap_speed := 30 
var drag_speed := 20
var zone_speed := 10
var ai_speed := 7

func avilable_moves_to_string() -> String:
	var out = "{ "
	
	for board_id: int in avilable_moves.keys():
		out += str(board_id) + ":"
		
		for board_state: String in avilable_moves[board_id]:
			out += "\n\t"
			if board_state == avilable_moves[board_id].keys()[0]: out += "{ "
			else: out += "  "
			out += '"' + board_state + '": ['
			
			for i: int in range(avilable_moves[board_id][board_state].size()):
				var move: Array = avilable_moves[board_id][board_state][i]
				out += str(move[0]) + "-->" + move[1].ID
				if i != avilable_moves[board_id][board_state].size()-1: out += ", "
				else: out += "]"
			if avilable_moves[board_id][board_state].size() == 0: out += "]"
		
		if avilable_moves[board_id].size() == 1: out += " }"
		else: out += "\n\t}"
		
	out += "\n}"
	return out
#endregion

# Dropzones
var highlight_zone := false
signal zones_generated

# Mouse
var update_cursor := false

#region Game
var can_restart: bool = false
var game_over: bool = false :
	set(val):
		if game_over != val:
			game_over = val
			
			if game_over: 
				if Mouse.context != Mouse.CONTEXT.CURSOR:
					Mouse.set_context(Mouse.CONTEXT.CURSOR)
				
				for piece: Piece in get_tree().get_nodes_in_group("Piece"):
					piece.can_move = false
#endregion
