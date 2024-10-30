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
@export var show_dropzones: bool = DV.SHOW_DROPZONES : # false
	set(val):
		if val != show_dropzones:
			show_dropzones = val
			if board: board.show_dropzones = show_dropzones
			if not Engine.is_editor_hint(): 
				Global.show_dorpzones = show_dropzones
				
				# Make sure that highlight_zones remains off when turning show_dorpzones off.
				if not show_dropzones and not highlight_dropzones:
					Global.highlight_zone = false

@export var highlight_dropzones: bool = DV.HIGHLIGHT_DROPZONES : # false
	set(val):
		if val != highlight_dropzones:
			highlight_dropzones = val
			if board: board.highlight_dropzones = highlight_dropzones
			if not Engine.is_editor_hint(): Global.highlight_dropzones = highlight_dropzones
#
@export var show_zone_ID: bool = DV.SHOW_ZONE_ID : # false
	set(val):
		show_zone_ID = val
		if board: board.show_zone_ID = show_zone_ID
		if not Engine.is_editor_hint(): Global.show_zone_ID = show_zone_ID

@export var dropzone_color: Color = DV.DROPZONE_COLOR : # Color(Color.MEDIUM_SEA_GREEN, 0.25)
	set(color):
		dropzone_color = color
		if grid: grid.dropzone_color = dropzone_color
		if not Engine.is_editor_hint(): Global.dropzone_color = dropzone_color

@export_range(0, 50) var area_offset: int = DV.DROPZONE_AREA_OFFSET : # 6
	set(offset):
		if offset < 0: area_offset = 0
		elif offset > 50: area_offset = 50
		else: area_offset = offset
		if grid: grid.area_offset = area_offset
		if not Engine.is_editor_hint(): Global.area_offset = area_offset
#endregion

#region Speed Limits Export Variables
@export_category("Speed Limits")
# Range: 20-35, 30
@export_range(DV.SNAP_SPEED[MIN], DV.SNAP_SPEED[MAX], 1) var snap_speed :int = DV.SNAP_SPEED[DEF] :
	set(num):
		if num != snap_speed:
			if num < DV.SNAP_SPEED[MIN]: snap_speed = DV.SNAP_SPEED[MIN]
			elif num > DV.SNAP_SPEED[MAX]: snap_speed = DV.SNAP_SPEED[MAX]
			else: snap_speed = num
			if not Engine.is_editor_hint(): Global.snap_speed = snap_speed

# Range: 7-20, 20
@export_range(DV.DRAG_SPEED[MIN], DV.DRAG_SPEED[MAX], 1) var drag_speed :int = DV.DRAG_SPEED[DEF] :
	set(num):
		if num != drag_speed:
			if num < DV.DRAG_SPEED[MIN]: drag_speed = DV.DRAG_SPEED[MIN]
			elif num > DV.DRAG_SPEED[MAX]: drag_speed = DV.DRAG_SPEED[MAX]
			else: drag_speed = num
			if not Engine.is_editor_hint(): Global.drag_speed = drag_speed

# Range: 7-20, 10
@export_range(DV.ZONE_SPEED[MIN], DV.ZONE_SPEED[MAX], 1) var zone_speed :int = DV.ZONE_SPEED[DEF] :
	set(num):
		if num != zone_speed:
			if num < DV.ZONE_SPEED[MIN]: zone_speed = DV.ZONE_SPEED[MIN]
			elif num > DV.ZONE_SPEED[MAX]: zone_speed = DV.ZONE_SPEED[MAX]
			else: zone_speed = num
			if not Engine.is_editor_hint(): Global.zone_speed = zone_speed

# Range: 3-10, 7
@export_range(DV.AI_SPEED[MIN], DV.AI_SPEED[MAX], 1) var ai_speed :int = DV.AI_SPEED[DEF] :
	set(num):
		if num != ai_speed:
			if num < DV.AI_SPEED[MIN]: ai_speed = DV.AI_SPEED[MIN]
			elif num > DV.AI_SPEED[MAX]: ai_speed = DV.AI_SPEED[MAX]
			else: ai_speed = num
			if not Engine.is_editor_hint(): Global.ai_speed = ai_speed
#endregion
#endregion
#endregion

func _ready():
	self.position = Vector2(324, 0)
	
	if not Engine.is_editor_hint():
		show_dropzones = Global.show_dorpzones
		highlight_dropzones = Global.highlight_dropzones
		show_zone_ID = Global.show_zone_ID
		
		snap_speed = Global.snap_speed
		drag_speed = Global.drag_speed
		zone_speed = Global.zone_speed
		ai_speed = Global.ai_speed

# ------------------------------------------------------------------------------
# TESTING
# ------------------------------------------------------------------------------
func _input(_event):
	if Input.is_action_just_pressed("Show_Dropzones"): # S
		show_dropzones = not show_dropzones
	
	if Input.is_action_just_pressed("Highlight_Dropzone"): # H
		highlight_dropzones = not highlight_dropzones
	
	if Input.is_action_just_pressed("Toggle_Grid_ID"): # G
		show_zone_ID = not show_zone_ID
	
	if Input.is_action_just_pressed("Print"): # P
		print("     Show Dropzones: ", Global.show_dorpzones, ":", show_dropzones)
		print("Highlight Dropzones: ", Global.highlight_zone, ":", Global.highlight_dropzones, ":", highlight_dropzones)
		print("       Show Zone ID: ", Global.show_zone_ID, ":", show_zone_ID)
		print("     Dropzone Color: ", Global.dropzone_color, ":", dropzone_color)
		print("        Area Offset: ", Global.area_offset, ":", area_offset)
		print()
		print("Snap Speed: ", Global.snap_speed, ":", snap_speed)
		print("Drag Speed: ", Global.drag_speed, ":", drag_speed)
		print("Zone Speed: ", Global.zone_speed, ":", zone_speed)
		print("  AI Speed: ", Global.ai_speed, ":", ai_speed)
		print()
