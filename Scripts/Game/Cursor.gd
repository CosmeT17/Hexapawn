extends Node

#region Constants and Variables
#region Enums
enum Context {CURSOR, SELECT, GRAB} # Contexts for cursor icon.
enum Mode {FREE, CONFINED} # Mouse can/cannot leave window.
#endregion

#region Cursor Icon Textures
const CURSOR_PNG: CompressedTexture2D = preload("res://Textures/Cursors/Cursor.png")
const SELECT_PNG: CompressedTexture2D = preload("res://Textures/Cursors/Select_2.png")
const GRAB_PNG: CompressedTexture2D = preload("res://Textures/Cursors/Cursor.png")
#endregion

#region Current Context and Mode
var context: int: set = set_context
var mode: int: set = set_mode
#endregion
#endregion

# Called when the node enters the scene tree for the first time.
func _ready():
	# Setting the starting context and mode.
	set_context(Context.SELECT)
	set_mode(Mode.FREE)

# Updates the cursor icon based on the context.
func set_context(val: int) -> void:
	match val:
		Context.CURSOR: Input.set_custom_mouse_cursor(CURSOR_PNG)
		Context.SELECT: Input.set_custom_mouse_cursor(SELECT_PNG)
		Context.GRAB: Input.set_custom_mouse_cursor(GRAB_PNG)
	context = val

# Updates the mouse mode based on the context.
func set_mode(val: int) -> void:
	match val:
		Mode.FREE: Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Mode.CONFINED: Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	mode = val
