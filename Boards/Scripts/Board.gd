@tool
extends Node
class_name Board

const BOARD_3X3_TEXTURE = preload("res://Boards/Textures/Board/Board_3x3_Texture.png") as AtlasTexture
const BOARD_4X4_TEXTURE = preload("res://Boards/Textures/Board/Board_4x4_Texture.png") as AtlasTexture
const BOARD_DEFAULT_TEXTURE = preload("res://Boards/Textures/Board/Board_Default_Texture.png") as AtlasTexture

const board_textures: Dictionary = {
	Global.BOARD_3X3: BOARD_3X3_TEXTURE,
	Global.BOARD_4X4: BOARD_4X4_TEXTURE,
	Global.NONE: BOARD_DEFAULT_TEXTURE
}

@onready var sprite = $Sprite as Sprite2D
@onready var grid = $Grid as Grid

@export_enum("3x3:3", "4x4:4", "None:0") var dimensions: int = 0 :
	set(dim):
		dimensions = dim
		update_board()

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

@export_category("Testing")
@export var show_dropzones: bool = false :
	set(val):
		show_dropzones = val
		if grid: grid.show_dropzones = show_dropzones

func _ready():
	update_board()
	grid.show_dropzone_ID = show_zone_ID
	grid.show_dropzones = show_dropzones
	if not Engine.is_editor_hint():
			Global.highlight_zone = false if show_dropzones else highlight_dropzones

func update_board() -> void:
	if sprite: sprite.texture = board_textures[dimensions]
	if grid: grid.dimensions = dimensions
