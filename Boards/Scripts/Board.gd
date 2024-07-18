@tool
extends Node2D
class_name Board

#region Variables and Constants
#region Constants
enum {BOARD_3X3 = 3, BOARD_4X4 = 4, NONE = 0}

const BOARD_3X_3_TEXTURE = preload("res://Boards/Textures/Board/Board_3x3_Texture.png") as AtlasTexture
const BOARD_4X_4_TEXTURE = preload("res://Boards/Textures/Board/Board_4x4_Texture.png") as AtlasTexture
const BOARD_DEFAULT_TEXTURE = preload("res://Boards/Textures/Board/Board_Default_Texture.png") as AtlasTexture

const TEXTURES: Dictionary = {
	BOARD_3X3: BOARD_3X_3_TEXTURE,
	BOARD_4X4: BOARD_4X_4_TEXTURE,
	NONE: BOARD_DEFAULT_TEXTURE
}
#endregion

#region Children Variables
@onready var sprite = $Sprite as Sprite2D
@onready var grid = $Grid as Grid
#endregion

#region Export Variables
@export_enum("3x3:3", "4x4:4", "None:0") var dimensions = 0 as int :
	set(dim):
		dimensions = dim
		if(sprite): update_texture()

@export_category("Testing")
@export var show_grid = false as bool
#endregion
#endregion

func _ready():
	Global.show_grid = show_grid
	if not Engine.is_editor_hint() and not show_grid:
		grid.visible = false
		
	update_texture()

func update_texture() -> void:
	sprite.texture = TEXTURES[dimensions]
	grid.dimensions = dimensions
