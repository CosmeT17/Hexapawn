extends Node

# Enums
enum {BOARD_3X3 = 3, BOARD_4X4 = 4, NONE = 0}
enum {WHITE, BLACK, UNTEXTURED}
enum {UP = 1, DOWN = -1}
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
