extends Node
class_name Board

enum {BOARD_3X3 = 3, BOARD_4X4 = 4, NONE = 0}

@onready var sprite = $Sprite as Sprite2D

var board_textures = {
	BOARD_3X3: null,
	BOARD_4X4: null,
	NONE: null
}

@export_enum("3x3:3", "4x4:4", "None:0") var dimensions = 0 as int :
	set(dim):
		dimensions = dim
		if sprite: update_texture()

func _ready():
	update_texture()

func update_texture() -> void:
	sprite.texture = board_textures[dimensions]

# Order: BOARD_3X3, BOARD_4X4, NONE
func set_textures(textures: Array[AtlasTexture]) -> void:
	for i: int in range(board_textures.size()):
		board_textures[board_textures.keys()[i]] = textures[i]
