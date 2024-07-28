extends Node

#region Constants and Variables
#region Constants
enum CONTEXT {CURSOR, SELECT, GRAB} # Contexts for cursor icon.
enum MODE {FREE, CONFINED} # Mouse can/cannot leave window.

const CURSOR_TEXTURES: Dictionary = {
	CONTEXT.CURSOR: preload("res://Game/Textures/Cursor/Cursor.png") as AtlasTexture,
	CONTEXT.SELECT: preload("res://Game/Textures/Cursor/Select.png") as AtlasTexture,
	CONTEXT.GRAB: preload("res://Game/Textures/Cursor/Grab.png") as AtlasTexture
}
const CURSOR_HOTSPOTS: Dictionary = {
	CONTEXT.CURSOR: Vector2(0, 0),
	CONTEXT.SELECT: Vector2(22, 28),
	CONTEXT.GRAB: Vector2(18, 18)
}
#endregion

#region Variables
var context: int: set = set_context
var mode: int: set = set_mode
#endregion
#endregion

# Called when the node enters the scene tree for the first time.
func _ready():
	# Setting the starting context and mode.
	set_context(CONTEXT.CURSOR)
	set_mode(MODE.FREE)

# Updates the cursor icon based on the context.
func set_context(val: int) -> void:
	context = val
	Input.set_custom_mouse_cursor(
		CURSOR_TEXTURES[context],
		Input.CURSOR_ARROW,
		CURSOR_HOTSPOTS[context]
	)
	
# Updates the mouse mode based on the context.
func set_mode(val: int) -> void:
	mode = val
	match mode:
		MODE.FREE: Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		MODE.CONFINED: Input.mouse_mode = Input.MOUSE_MODE_CONFINED
