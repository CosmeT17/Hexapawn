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

@export_category("Zones")
@export var show_grid := false
@export var show_zone := true

@export_category("Pieces")
@export var snap_speed := 30 
@export var drag_speed := 20 
@export var zone_speed := 10

var board_textures = {
	BOARD_3X3: null,
	BOARD_4X4: null,
	NONE: null
}
#endregion

func _ready():
	update_board()
	
	if not Engine.is_editor_hint():
		Global.show_zone = true if (show_zone and not show_grid) else false
		Global.snap_speed = snap_speed
		Global.drag_speed = drag_speed
		Global.zone_speed = zone_speed
		
		if show_grid:
			for zone: Dropzone in get_tree().get_nodes_in_group("Zone"):
				zone.visible = true

func update_board() -> void:
	if sprite: sprite.texture = board_textures[dimensions]
	if grid: grid.dimensions = dimensions

# Order: BOARD_3X3, BOARD_4X4, NONE
func set_textures(textures: Array[AtlasTexture]) -> void:
	for i: int in range(board_textures.size()):
		board_textures[board_textures.keys()[i]] = textures[i]
