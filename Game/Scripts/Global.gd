extends Node

# Enums
enum {NORTH, EAST, SOUTH, WEST, NORTH_EAST, SOUTH_EAST, SOUTH_WEST, NORTH_WEST}
enum {BOARD_3X3 = 3, BOARD_4X4 = 4, NONE = 0}
enum {WHITE, BLACK, UNTEXTURED}
enum {BLUE, RED}

# Pieces
var is_selected := false
var snap_speed := 30 
var drag_speed := 20
var zone_speed := 10

# Dropzones
var highlight_zone := false
signal zones_generated

# Mouse
var turn_switched := false
