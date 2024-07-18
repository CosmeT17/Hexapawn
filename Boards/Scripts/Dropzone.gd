@tool
extends Marker2D
class_name Dropzone

#region Constants and Variables
const ALPHA:= 0.25
const ALPHA_8:= 64

@export var radius: int = 100 :
	set(size):
		radius = size
		gizmo_extents = radius

@export var color: Color = Color(Color.MEDIUM_SEA_GREEN, ALPHA):
	set(col):
		color = col
		#if col.a8 == ALPHA_8 or col.a8 == 0: color = col
		queue_redraw()

@export var invisible: bool = false:
	set(val):
		invisible = val
		if invisible: color = Color(color, 0)
		else: color = Color(color, ALPHA)

@onready var label_id = $Label_ID as Label
var coordinates: Vector2
var ID: String
var piece: Piece
#endregion

func _ready():
	ID = String(name) if name != "Dropzone" else "A0"
	label_id.text = ID
	
	if not Engine.is_editor_hint(): 
		invisible = true

func _draw():
	draw_circle(Vector2.ZERO, radius, color)

# str() Override
func _to_string():
	return ID
