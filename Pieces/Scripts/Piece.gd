extends Node2D
class_name Piece

#region Variables and Constants
#region Constants
enum {WHITE, BLACK, UNTEXTURED}
enum {BLUE, RED}
enum {BOARD_3X3 = 3, BOARD_4X4 = 4}
enum {UP = 1, DOWN = -1}

const LABEL_WHITE_PIECE_THEME_3X3 = preload("res://Pieces/Themes/Label_White_Piece_Theme_3x3.tres") as Theme
const LABEL_BLACK_PIECE_THEME_3X3 = preload("res://Pieces/Themes/Label_Black_Piece_Theme_3x3.tres") as Theme
const LABEL_WHITE_PIECE_THEME_4X4 = preload("res://Pieces/Themes/Label_White_Piece_Theme_4x4.tres") as Theme
const LABEL_BLACK_PIECE_THEME_4X4 = preload("res://Pieces/Themes/Label_Black_Piece_Theme_4x4.tres") as Theme

const SCALE_AMOUNT: Dictionary = {
	BOARD_3X3: Vector2(1.0, 1.0),
	BOARD_4X4: Vector2(0.8, 0.8)
}
const LABEL_SIZE: Dictionary = {
	BOARD_3X3: Vector2(40, 40),
	BOARD_4X4: Vector2(32, 32),
}

const LABEL_THEMES: Dictionary = {
	[WHITE, BOARD_3X3]: {
		"Theme": LABEL_WHITE_PIECE_THEME_3X3,
		"Size": LABEL_SIZE[BOARD_3X3],
		"Letter": 'W'
	},
	[WHITE, BOARD_4X4]: {
		"Theme": LABEL_WHITE_PIECE_THEME_4X4,
		"Size": LABEL_SIZE[BOARD_4X4],
		"Letter": 'W'
	},
	[BLACK, BOARD_3X3]: {
		"Theme": LABEL_BLACK_PIECE_THEME_3X3,
		"Size": LABEL_SIZE[BOARD_3X3],
		"Letter": 'B'
	},
	[BLACK, BOARD_4X4]: {
		"Theme": LABEL_BLACK_PIECE_THEME_4X4,
		"Size": LABEL_SIZE[BOARD_4X4],
		"Letter": 'B'
	},
	[UNTEXTURED, BOARD_3X3]: {
		"Theme": LABEL_WHITE_PIECE_THEME_3X3,
		"Size": LABEL_SIZE[BOARD_3X3],
		"Letter": '_'
	},
	[UNTEXTURED, BOARD_4X4]: {
		"Theme": LABEL_WHITE_PIECE_THEME_4X4,
		"Size": LABEL_SIZE[BOARD_4X4],
		"Letter": '_'
	}
}

const MOUSE_OFFSET = Vector2(16, 0) as Vector2
#endregion

#region Children Variables
@onready var area = $Sprite/Area as Area2D
@onready var sprite = $Sprite as Sprite2D
@onready var name_label = $Name_Label as Label
@onready var label_anchor = $Sprite/Label_Anchor as Marker2D
#endregion

#region Export Variables
@export_category("Customization")
@export_enum("White", "Black", "Untextured") var piece_color = 2 as int :
	set(color):
		piece_color = color
		if (sprite): update_texture()
		if(name_label): update_label()

@export_enum("Blue", "Red") var eye_color = 0 as int :
	set(color):
		eye_color = color
		if (sprite): update_texture()

@export_enum("3x3 Board:3", "4x4 Board:4") var piece_size = 3 as int :
	set(size):
		piece_size = size
		if(sprite and name_label): update_scale()
#endregion

#region Global Variables
var piece_textures = {
	[WHITE, BLUE]: null,
	[WHITE, RED]: null,
	[BLACK, BLUE]: null,
	[BLACK, RED]: null,
	UNTEXTURED: null
} as Dictionary

#region Dragging
var mouse_on_area: bool = false
var is_selected: bool = false
var snap_complete: bool = false
#endregion

#region Zones
var current_zone: Dropzone:
	set(zone):
		if current_zone and current_zone.piece:
			if current_zone.piece == self: current_zone.piece = null
		current_zone = zone
		current_zone.piece = self
		
var initial_zone: Dropzone
var hovered_zone: Dropzone
#endregion
#endregion
#endregion

func _ready():
	if not Engine.is_editor_hint():
		#name_label.visible = false
		area.mouse_entered.connect(on_area_mouse_entered)
		area.mouse_exited.connect(on_area_mouse_exited)
		area.input_event.connect(on_area_input_event)
	
	update_texture()
	update_label()
	update_scale()
	
	# Assigning the initial zone.
	for zone: Dropzone in get_tree().get_nodes_in_group("Zone"):
		if global_position.distance_to(zone.global_position) < zone.radius:
			initial_zone = zone
			global_position = zone.global_position
			break
	current_zone = initial_zone

#region Update/Set Functions
# Order: White_Blue, White_Red, Black_Blue, Black_Red, Untextured
func set_textures(textures: Array[AtlasTexture]) -> void:
	for i: int in range(piece_textures.size()):
		piece_textures[piece_textures.keys()[i]] = textures[i]

func update_texture() -> void:
	if piece_color != UNTEXTURED: 
		sprite.texture = piece_textures[[piece_color, eye_color]]
	else: 
		sprite.texture = piece_textures[UNTEXTURED]

func update_label() -> void:
	name_label.theme = LABEL_THEMES[[piece_color, piece_size]]["Theme"]
	name_label.text = LABEL_THEMES[[piece_color, piece_size]]["Letter"] + name_label.text.substr(1)

func update_scale() -> void:
	sprite.scale = SCALE_AMOUNT[piece_size]
	name_label.global_position = label_anchor.global_position
	name_label.theme = LABEL_THEMES[[piece_color, piece_size]]["Theme"]
	name_label.size = LABEL_THEMES[[piece_color, piece_size]]["Size"]
#endregion

#region Cursor Update/Dragging Functions
func on_area_mouse_entered() -> void:
	mouse_on_area = true
	if Cursor.context != Cursor.CONTEXT.GRAB:
		Cursor.set_context(Cursor.CONTEXT.SELECT)

func on_area_mouse_exited() -> void:
	if is_selected: snap_complete = true
	mouse_on_area = false
	if Cursor.context != Cursor.CONTEXT.GRAB:
		Cursor.set_context(Cursor.CONTEXT.CURSOR)

# Start dragging.
func on_area_input_event(_viewport, _event, _shape_idx) ->void:
	if Input.is_action_just_pressed("Click"):
		Cursor.set_context(Cursor.CONTEXT.GRAB)
		Cursor.set_mode(Cursor.MODE.CONFINED)
		z_index = 1
		is_selected = true

# Do the dragging/ Move towards the current zone's center.
func _physics_process(delta):
	#region Dragging
	if is_selected:
		# Snap to cursor.
		if not snap_complete:
			if abs(global_position - get_global_mouse_position()) != MOUSE_OFFSET:
				global_position = lerp(
					global_position,
					get_global_mouse_position() + MOUSE_OFFSET,
					Global.snap_speed * delta
				)
			else: snap_complete = true
		
		# Drag piece towards the cursor:
		else:
			global_position = lerp(
				global_position,
				get_global_mouse_position() + MOUSE_OFFSET,
				Global.drag_speed * delta
			)
	#endregion
	
	#region Move Towards Zone
	elif not Engine.is_editor_hint():
		if current_zone and global_position != current_zone.global_position:
			global_position = lerp(
				global_position, 
				current_zone.global_position, 
				Global.zone_speed * delta
			)
			
			# Smooth-over movement
			if round(abs((global_position - current_zone.global_position))) <= Vector2(0.10, 0.10):
				global_position = current_zone.global_position
				z_index = 0
	#endregion

# Stop dragging
func _input(_event):
	# Stop dragging.
	if is_selected and Input.is_action_just_released("Click"):
		is_selected = false
		snap_complete = false
		if mouse_on_area: Cursor.set_context(Cursor.CONTEXT.SELECT)
		else: Cursor.set_context(Cursor.CONTEXT.CURSOR)
		Cursor.set_mode(Cursor.MODE.FREE)
		if hovered_zone: hovered_zone.invisible = true
		update_zone()
#endregion

#region Zone Functions
# Returns true if the piece can legally move to the given zone, otherwise false. [ABSTRACT]
func is_zone_valid(zone: Dropzone) -> bool:
	if zone.piece and zone.piece.piece_color == self.piece_color: return false
	return true

 # Returns the closest valid dropzone to the selected piece.
func nearest_zone() -> Dropzone:
	for zone: Dropzone in get_tree().get_nodes_in_group("Zone"):
		if global_position.distance_to(zone.global_position) < zone.radius:
			if zone != current_zone:
				
				# Changing between zones -> make the old one invisible.
				if hovered_zone and hovered_zone != zone:
					hovered_zone.invisible = true
				hovered_zone = zone
				
				if is_zone_valid(zone):
					return zone
	
	# Moving off a zone into a place with no zones -> make old one invisible.
	if hovered_zone: hovered_zone.invisible = true
	hovered_zone = null
	
	return current_zone 

# Updates the piece's current zone to the selected zone. 
func update_zone(zone: Dropzone = nearest_zone()) -> void:
	current_zone = zone

# Show the closest zone's highlight.
func _process(_delta):
	if is_selected and Global.show_zone:
		nearest_zone()
		if hovered_zone:
			if hovered_zone != current_zone:
				hovered_zone.invisible = false
#endregion
