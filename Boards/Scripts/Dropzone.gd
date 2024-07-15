@tool
extends Marker2D
class_name Dropzone

#region Constants and Variables
const ACTIVE_COLOR: Color = Color(Color.MEDIUM_SEA_GREEN, 0.25)

@export var radius: int = 100 :
	set(size):
		radius = size
		gizmo_extents = radius

@onready var label_id = $Label_ID
var coordinates: Vector2
var ID: String
var piece: Piece
#endregion

func _ready():
	ID = name
	label_id.text = ID
	
	if not Engine.is_editor_hint():
		#visible = false
		pass

func _draw():
	draw_circle(Vector2.ZERO, radius, ACTIVE_COLOR)

# str() Override
func _to_string():
	return ID
