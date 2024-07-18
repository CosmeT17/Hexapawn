extends Node

#region Constants and Variables
#region Enums
enum CONTEXT {CURSOR, SELECT, GRAB} # Contexts for cursor icon.
enum MODE {FREE, CONFINED} # Mouse can/cannot leave window.
#endregion

#region Cursor Icon Textures
const CURSOR_PNG: AtlasTexture = preload("res://Game/Textures/Cursor/Cursor.png")
const SELECT_PNG: AtlasTexture = preload("res://Game/Textures/Cursor/Select.png")
const GRAB_PNG: AtlasTexture = preload("res://Game/Textures/Cursor/Grab.png")
#endregion

#region Current Context and Mode
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
	match val:
		CONTEXT.CURSOR: Input.set_custom_mouse_cursor(CURSOR_PNG)
		CONTEXT.SELECT: Input.set_custom_mouse_cursor(SELECT_PNG)
		CONTEXT.GRAB: Input.set_custom_mouse_cursor(GRAB_PNG)
	context = val

# Updates the mouse mode based on the context.
func set_mode(val: int) -> void:
	match val:
		MODE.FREE: Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		MODE.CONFINED: Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	mode = val
