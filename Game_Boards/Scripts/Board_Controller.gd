@tool
extends Node
class_name BoardController

#region Variables and Constants
const DV = preload("res://Game/Scripts/Default_Values.gd")
enum {DEF, MIN, MAX}

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
# Range: 20-35, 30
@export_range(DV.SNAP_SPEED[MIN], DV.SNAP_SPEED[MAX], 1) var snap_speed :int = DV.SNAP_SPEED[DEF] :
	set(num):
		if num < DV.SNAP_SPEED[MIN]: snap_speed = DV.SNAP_SPEED[MIN]
		elif num > DV.SNAP_SPEED[MAX]: snap_speed = DV.SNAP_SPEED[MAX]
		else: snap_speed = num
		
		if not Engine.is_editor_hint(): 
			Global.snap_speed = snap_speed

# Range: 7-20, 20
@export_range(DV.DRAG_SPEED[MIN], DV.DRAG_SPEED[MAX], 1) var drag_speed :int = DV.DRAG_SPEED[DEF] :
	set(num):
		if num < DV.DRAG_SPEED[MIN]: drag_speed = DV.DRAG_SPEED[MIN]
		elif num > DV.DRAG_SPEED[MAX]: drag_speed = DV.DRAG_SPEED[MAX]
		else: drag_speed = num
		
		if not Engine.is_editor_hint(): 
			Global.drag_speed = drag_speed

# Range: 7-20, 10
@export_range(DV.ZONE_SPEED[MIN], DV.ZONE_SPEED[MAX], 1) var zone_speed :int = DV.ZONE_SPEED[DEF] :
	set(num):
		if num < DV.ZONE_SPEED[MIN]: zone_speed = DV.ZONE_SPEED[MIN]
		elif num > DV.ZONE_SPEED[MAX]: zone_speed = DV.ZONE_SPEED[MAX]
		else: zone_speed = num
		
		if not Engine.is_editor_hint(): 
			Global.zone_speed = zone_speed

# Range: 3-10, 7
@export_range(DV.AI_SPEED[MIN], DV.AI_SPEED[MAX], 1) var ai_speed :int = DV.AI_SPEED[DEF] :
	set(num):
		if num < DV.AI_SPEED[MIN]: ai_speed = DV.AI_SPEED[MIN]
		elif num > DV.AI_SPEED[MAX]: ai_speed = DV.AI_SPEED[MAX]
		else: ai_speed = num
		
		if not Engine.is_editor_hint(): 
			Global.ai_speed = ai_speed
#endregion
#endregion
#endregion

func _ready():
	self.position = Vector2(324, 0)

func _enter_tree():
	if not Engine.is_editor_hint():
		if Global.snap_speed != snap_speed: snap_speed = Global.snap_speed
		if Global.drag_speed != drag_speed: drag_speed = Global.drag_speed
		if Global.zone_speed != zone_speed: zone_speed = Global.zone_speed
		if Global.ai_speed != ai_speed: ai_speed = Global.ai_speed

# ------------------------------------------------------------------------------
# TESTING
# ------------------------------------------------------------------------------
func _input(_event):
	if Input.is_action_just_pressed("Test"):
		print("TEST")
