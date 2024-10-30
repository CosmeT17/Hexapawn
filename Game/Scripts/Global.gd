extends Node
const DV = preload("res://Game/Scripts/Default_Values.gd")

#region Enums
enum {NORTH, EAST, SOUTH, WEST, NORTH_EAST, SOUTH_EAST, SOUTH_WEST, NORTH_WEST}
enum {BOARD_3X3 = 3, BOARD_4X4 = 4, NONE = 0}
enum {HEXAPAWN_3X3, HEXAPAWN_4x4}
enum {WHITE, BLACK, UNTEXTURED}
enum {BLUE, RED}
#endregion

#region Pieces
var num_pieces_mouse_on_area: int = 0 :
	set(num):
		num_pieces_mouse_on_area = num
		if num < 0: num_pieces_mouse_on_area = 0
		elif num > 2: num_pieces_mouse_on_area = 2

var available_moves: Dictionary = {}
var is_selected := false
var can_move := true
var snap_speed: int = DV.SNAP_SPEED[0] # Range: 20-35, 30
var drag_speed: int = DV.DRAG_SPEED[0] # Range: 7-20, 20
var zone_speed: int = DV.ZONE_SPEED[0] # Range: 7-20, 10
var ai_speed: int = DV.AI_SPEED[0] # Range: 3-10, 7

func available_moves_to_string() -> String:
	var out = "{ "
	
	for board_id: int in available_moves.keys():
		out += str(board_id) + ":"
		
		for board_state: String in available_moves[board_id]:
			out += "\n\t"
			if board_state == available_moves[board_id].keys()[0]: out += "{ "
			else: out += "  "
			out += '"' + board_state + '": ['
			
			for i: int in range(available_moves[board_id][board_state].size()):
				var move: Array = available_moves[board_id][board_state][i]
				out += str(move[0]) + "-->" + move[1].ID
				if i != available_moves[board_id][board_state].size()-1: out += ", "
				else: out += "]"
			if available_moves[board_id][board_state].size() == 0: out += "]"
		
		if available_moves[board_id].size() == 1: out += " }"
		else: out += "\n\t}"
		
	out += "\n}"
	return out
#endregion

#region Dropzones
var show_dorpzones: bool =  DV.SHOW_DROPZONES # false
var highlight_zone: bool = DV.HIGHLIGHT_DROPZONES # false
var highlight_dropzones: bool = DV.HIGHLIGHT_DROPZONES # false : Remember Board_Controller Value
var show_zone_ID: bool = DV.SHOW_ZONE_ID # false
var dropzone_color: Color = DV.DROPZONE_COLOR # Color(Color.MEDIUM_SEA_GREEN, 0.25)
var area_offset: int = DV.DROPZONE_AREA_OFFSET # 6
signal zones_generated
signal zones_destroyed
#endregion

#region Game
signal signal_game_over
signal piece_finished_moving

var update_cursor := false
var is_tie_detection_complete := false
var can_restart := false

var game_over: bool = false :
	set(val):
		if game_over != val:
			game_over = val
			
			if game_over:
				signal_game_over.emit()
				can_move = false
				num_pieces_mouse_on_area = 0
				if Mouse.context != Mouse.CONTEXT.CURSOR:
					Mouse.set_context(Mouse.CONTEXT.CURSOR)
#endregion
