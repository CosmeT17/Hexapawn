@tool
extends Marker2D
class_name Dropzone

#region Constants and Variables
#region Export Variables
@export var radius: int = 100 :
	set(size):
		radius = size
		gizmo_extents = radius
		if not ID_centered: 
			ID_centered = false

var alpha: float = 0.25
@export var color: Color = Color(Color.MEDIUM_SEA_GREEN, 0.25) :
	set(col):
		if invisible: 
			color = Color(col, 0)
		else: 
			color = col
			alpha = color.a
		queue_redraw()
		print(alpha)

@export var invisible: bool = false :
	set(val):
		invisible = val
		color = Color(color, alpha)

@export var ID_centered: bool = true :
	set(val):
		ID_centered = val
		if label_id:
			if ID_centered: 
				label_id.position = Vector2(-label_id.size.x / 2, -label_id.size.y / 2)
			else: 
				label_id.position = Vector2(-radius, -radius)
#endregion

@onready var label_id = $Label_ID as Label
var coordinates: Vector2
var ID: String
var piece: Piece
#endregion

func _ready():
	ID = String(name) if name != "Dropzone" else "A0"
	label_id.text = ID

func _draw():
	draw_circle(Vector2.ZERO, radius, color)

# str() Override
func _to_string():
	return ID
