extends Node

# Enums
enum {NORTH, EAST, SOUTH, WEST, NORTH_EAST, SOUTH_EAST, SOUTH_WEST, NORTH_WEST}
enum {BOARD_3X3 = 3, BOARD_4X4 = 4, NONE = 0}
enum {WHITE, BLACK, UNTEXTURED}
enum {BLUE, RED}

#region Pieces
var num_pieces_mouse_on_area: int = 0 :
	set(num):
		num_pieces_mouse_on_area = num
		if num < 0: num_pieces_mouse_on_area = 0
		elif num > 2: num_pieces_mouse_on_area = 2

var is_selected := false
var snap_speed := 30 
var drag_speed := 20
var zone_speed := 10
var ai_speed := 7
#endregion

# Dropzones
var highlight_zone := false
signal zones_generated

# Mouse
var update_cursor := false

# Game
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
