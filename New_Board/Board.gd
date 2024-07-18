extends Node
class_name Board

#region Variables and Constants
enum {BOARD_3X3 = 3, BOARD_4X4 = 4, NONE = 0}

@onready var sprite = $Sprite as Sprite2D
@onready var grid = $Grid as Grid

@export_enum("3x3:3", "4x4:4", "None:0") var dimensions = 0 as int :
	set(dim):
		dimensions = dim
		update_board()

var board_textures = {
	BOARD_3X3: null,
	BOARD_4X4: null,
	NONE: null
}
#endregion

func _ready():
	update_board()

func update_board() -> void:
	if sprite: sprite.texture = board_textures[dimensions]
	if grid: grid.dimensions = dimensions

# Order: BOARD_3X3, BOARD_4X4, NONE
func set_textures(textures: Array[AtlasTexture]) -> void:
	for i: int in range(board_textures.size()):
		board_textures[board_textures.keys()[i]] = textures[i]
