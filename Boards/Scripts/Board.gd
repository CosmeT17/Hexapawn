@tool
extends Node
class_name Board

#region Variables and Constants
#region Textures
const BOARD_3X3_TEXTURE = preload("res://Boards/Textures/Board/Board_3x3_Texture.png") as AtlasTexture
const BOARD_4X4_TEXTURE = preload("res://Boards/Textures/Board/Board_4x4_Texture.png") as AtlasTexture
const BOARD_DEFAULT_TEXTURE = preload("res://Boards/Textures/Board/Board_Default_Texture.png") as AtlasTexture
const board_textures: Dictionary = {
	Global.BOARD_3X3: BOARD_3X3_TEXTURE,
	Global.BOARD_4X4: BOARD_4X4_TEXTURE,
	Global.NONE: BOARD_DEFAULT_TEXTURE
}
#endregion

#region Children Variables
@onready var sprite = $Sprite as Sprite2D
@onready var grid = $Grid as Grid
@onready var player_1 = $Players/Player_1 as Player
@onready var player_2 = $Players/Player_2 as Player
#endregion

#region Export Variables
@export_enum("3x3:3", "4x4:4", "None:0") var dimensions: int = 0 :
	set(dim):
		dimensions = dim
		update_board()

#region Dropzone Export Variables
@export_category("Dropzones")
@export var highlight_dropzones: bool = true :
	set(val):
		highlight_dropzones = val
		if not Engine.is_editor_hint():
			Global.highlight_zone = false if show_dropzones else highlight_dropzones

@export var show_zone_ID: bool = false :
	set(val):
		show_zone_ID = val
		if grid: grid.show_dropzone_ID = show_zone_ID
#endregion

@export_category("Testing")
@export var show_dropzones: bool = false :
	set(val):
		show_dropzones = val
		if grid: grid.show_dropzones = show_dropzones
#endregion
#endregion

func _ready():
	#region Initializing Export Variables
	update_board()
	grid.show_dropzone_ID = show_zone_ID
	grid.show_dropzones = show_dropzones
	if not Engine.is_editor_hint():
			Global.highlight_zone = false if show_dropzones else highlight_dropzones
	#endregion
	
	player_1.player_num = 1
	player_2.player_num = 2
	
	if not Engine.is_editor_hint():
		Global.zones_generated.emit()

func update_board() -> void:
	if sprite: sprite.texture = board_textures[dimensions]
	if grid: grid.dimensions = dimensions

# TESTING
func _input(_event):
	#region Switch Player Turns
	if Input.is_action_just_pressed("Test"):
		player_1.is_turn = not player_1.is_turn
	#endregion
	
	#region Print Player Vars
	elif Input.is_action_just_pressed("Test_Print"):
		const colors = {0: "WHITE", 1: "BLACK", 2: "UNTEXTURED"}
		const eye_col = {false: "BLUE", true: "RED"}
		
		for player: Player in [player_1, player_2]:
			print(player, ": ", player.player_num)
			print(player, ": ", colors[player.piece_color])
			print(player, ": ", eye_col[player.is_ai], '\n')
	#endregion
	
	#region Switch Player Colors
	elif Input.is_action_just_pressed("Change_Piece_Color"):
		if player_1.piece_color == Global.WHITE:
			player_1.piece_color = Global.BLACK
		else:
			player_1.piece_color = Global.WHITE
	#endregion
	
	#region Toggle Player_2 AI
	elif Input.is_action_just_pressed("Toggle_AI"):
		player_2.is_ai = not player_2.is_ai
	#endregion
