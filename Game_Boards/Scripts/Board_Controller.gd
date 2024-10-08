@tool
extends Node
class_name BoardController

#region Variables
#region Children Variables
@onready var board = get_children()[0] as Board
@onready var grid = board.get_node("Grid") as Grid
@onready var player_1 = board.get_node("Players/Player_1") as Player
@onready var player_2 = board.get_node("Players/Player_2") as Player
#endregion

#region Export Variables
#region Players Export Variables
@export_category("Players")
@export var can_move: bool = true :
	set(val):
		can_move = val

@export_enum("White", "Black") var color_player_1: int = 0 :
	set(num):
		color_player_1 = num

@export_enum("White", "Black") var color_player_2: int = 1 :
	set(num):
		color_player_2 = num

@export var ai_active: bool = false :
	set(val):
		ai_active = val

@export_range(-0.25, 1) var ai_delay: float = 0 :
	set(val):
		if ai_active:
			if val < 0.0: ai_delay = -0.25
			elif val < 0.25: ai_delay = 0.0
			elif val < 0.5: ai_delay = 0.25
			elif val < 0.75: ai_delay = 0.50
			elif val < 1.0: ai_delay = 0.75
			elif val == 1.0: ai_delay = 1.0

@export var show_piece_ID: bool = false :
	set(val):
		show_piece_ID = val
#endregion

#region Dropzones Export Variables
@export_category("Dropzones")
@export var show_dropzones: bool = false :
	set(val):
		show_dropzones = val

@export var highlight_dropzones: bool = false :
	set(val):
		highlight_dropzones = val
#
@export var show_zone_ID: bool = false :
	set(val):
		show_zone_ID = val

@export var dropzone_color: Color = Color(Color.MEDIUM_SEA_GREEN, 0.25) :
	set(color):
		dropzone_color = color

@export_range(0, 50) var area_offset: int = 0 :
	set(offset):
		area_offset = offset
#endregion

#region Speed Limits Export Variables
@export_category("Speed Limits")
@export_range(20, 35, 1) var snap_speed :int = 30 :
	set(num):
		snap_speed = num

@export_range(7, 20, 1) var drag_speed :int = 20 :
	set(num):
		drag_speed = num

@export_range(7, 20, 1) var zone_speed :int = 10 :
	set(num):
		zone_speed = num

@export_range(3, 10, 1) var ai_speed :int = 7 :
	set(num):
		ai_speed = num
#endregion
#endregion
#endregion

func _ready():
	self.position = Vector2(324, 0)
