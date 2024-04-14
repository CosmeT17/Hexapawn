extends Marker2D
class_name Dropzone

@export var radius: int = 100
const ACTIVE_COLOR: Color = Color(Color.MEDIUM_SEA_GREEN, 0.25)

var coordinates: Vector2
var ID: String
var pawn: Pawn

func _ready():
	visible = false

func _draw():
	draw_circle(Vector2.ZERO, radius, ACTIVE_COLOR)

# str() Override
func _to_string():
	return ID
