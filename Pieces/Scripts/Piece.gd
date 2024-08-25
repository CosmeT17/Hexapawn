extends Node2D
class_name Piece

#region Variables and Constants
#region Constants
const LABEL_WHITE_PIECE_THEME_3X3 = preload("res://Pieces/Themes/Label_White_Piece_Theme_3x3.tres") as Theme
const LABEL_BLACK_PIECE_THEME_3X3 = preload("res://Pieces/Themes/Label_Black_Piece_Theme_3x3.tres") as Theme
const LABEL_WHITE_PIECE_THEME_4X4 = preload("res://Pieces/Themes/Label_White_Piece_Theme_4x4.tres") as Theme
const LABEL_BLACK_PIECE_THEME_4X4 = preload("res://Pieces/Themes/Label_Black_Piece_Theme_4x4.tres") as Theme

const SCALE_AMOUNT: Dictionary = {
	Global.BOARD_3X3: Vector2(1.0, 1.0),
	Global.BOARD_4X4: Vector2(0.8, 0.8)
}
const LABEL_SIZE: Dictionary = {
	Global.BOARD_3X3: Vector2(40, 40),
	Global.BOARD_4X4: Vector2(32, 32),
}

const LABEL_THEMES: Dictionary = {
	[Global.WHITE, Global.BOARD_3X3]: {
		"Theme": LABEL_WHITE_PIECE_THEME_3X3,
		"Size": LABEL_SIZE[Global.BOARD_3X3],
		"Letter": 'W'
	},
	[Global.WHITE, Global.BOARD_4X4]: {
		"Theme": LABEL_WHITE_PIECE_THEME_4X4,
		"Size": LABEL_SIZE[Global.BOARD_4X4],
		"Letter": 'W'
	},
	[Global.BLACK, Global.BOARD_3X3]: {
		"Theme": LABEL_BLACK_PIECE_THEME_3X3,
		"Size": LABEL_SIZE[Global.BOARD_3X3],
		"Letter": 'B'
	},
	[Global.BLACK, Global.BOARD_4X4]: {
		"Theme": LABEL_BLACK_PIECE_THEME_4X4,
		"Size": LABEL_SIZE[Global.BOARD_4X4],
		"Letter": 'B'
	},
	[Global.UNTEXTURED, Global.BOARD_3X3]: {
		"Theme": LABEL_WHITE_PIECE_THEME_3X3,
		"Size": LABEL_SIZE[Global.BOARD_3X3],
		"Letter": '_'
	},
	[Global.UNTEXTURED, Global.BOARD_4X4]: {
		"Theme": LABEL_WHITE_PIECE_THEME_4X4,
		"Size": LABEL_SIZE[Global.BOARD_4X4],
		"Letter": '_'
	}
}

const GRAB_CURSOR_OFFSET = Vector2(0, -18) as Vector2
#endregion

#region Children Variables
@onready var sprite = $Sprite as Sprite2D
@onready var area = $Sprite/Area as Area2D
@onready var name_label = $Name_Label as Label
@onready var label_anchor = $Sprite/Label_Anchor as Marker2D
#endregion

#region Export Variables
@export var can_move: bool = true

@export_category("Customization")
@export_enum("White", "Black", "Untextured") var piece_color = 2 as int :
	set(color):
		if piece_color != color and color in [0, 1, 2]:
			piece_color = color
			if sprite: update_texture()
			if name_label: update_label()

@export_enum("Blue", "Red") var eye_color = 0 as int :
	set(color):
		if eye_color != color and color in [0, 1]:
			if eye_color != 0 and eye_color != 1:
				eye_color = 0
			eye_color = color
			if sprite: update_texture()

@export_enum("3x3 Board:3", "4x4 Board:4") var piece_size = 3 as int :
	set(size):
		if piece_size != size and size in [3, 4]:
			if piece_size != 3 and piece_size != 4:
				piece_size = 3
			piece_size = size
			if sprite and name_label: update_scale()

@export var show_ID = true as bool :
	set(val):
		if show_ID != val:
			show_ID = val
			if name_label: name_label.visible = show_ID
#endregion

#region Global Variables
var piece_textures = {
	[Global.WHITE, Global.BLUE]: null,
	[Global.WHITE, Global.RED]: null,
	[Global.BLACK, Global.BLUE]: null,
	[Global.BLACK, Global.RED]: null,
	Global.UNTEXTURED: null
} as Dictionary

#region Name RegEx
var letter_ID: String
var name_regex = RegEx.new() as RegEx
var do_update_name: bool = true
#endregion

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
		if current_zone: current_zone.piece = self
		
var initial_zone: Dropzone
var hovered_zone: Dropzone
var highlight_zone: bool = true
#endregion
#endregion
#endregion

func _ready():
	#region Name Regex Initialization
	var regex_pattern = r'^[_,W,B]' + letter_ID.to_upper() + r'\d*$'
	name_regex.compile(regex_pattern)
	#endregion
	
	#region Update Graphics
	update_texture()
	update_name()
	update_label()
	update_scale()
	if name_label: 
		name_label.visible = show_ID
	#endregion
	
	#region Connecting Signals
	renamed.connect(update_name)
	if not Engine.is_editor_hint():
		area.mouse_entered.connect(on_area_mouse_entered)
		area.mouse_exited.connect(on_area_mouse_exited)
		area.input_event.connect(on_area_input_event)
		Global.zones_generated.connect(assign_initial_zone)
	#endregion

#region Update/Set Functions
# Order: White_Blue, White_Red, Black_Blue, Black_Red, Untextured
func set_textures(textures: Array[AtlasTexture]) -> void:
	for i: int in range(piece_textures.size()):
		piece_textures[piece_textures.keys()[i]] = textures[i]

func update_texture() -> void:
	if piece_color != Global.UNTEXTURED: 
		sprite.texture = piece_textures[[piece_color, eye_color]]
	else: 
		sprite.texture = piece_textures[Global.UNTEXTURED]

func update_label() -> void:
	name_label.theme = LABEL_THEMES[[piece_color, piece_size]]["Theme"]
	name_label.text = LABEL_THEMES[[piece_color, piece_size]]["Letter"] + name_label.text.substr(1)
	do_update_name = false
	name = name_label.text

func update_scale() -> void:
	sprite.scale = SCALE_AMOUNT[piece_size]
	name_label.global_position = label_anchor.global_position
	name_label.theme = LABEL_THEMES[[piece_color, piece_size]]["Theme"]
	name_label.size = LABEL_THEMES[[piece_color, piece_size]]["Size"]

# If the given name is valid, update the name_label to match.
func update_name() -> void:
	if do_update_name:
		do_update_name = false
		var new_name = name.to_upper()
		
		if name_regex.search(new_name):
			name_label.text = new_name
			name = new_name
		else: name = name_label.text
		
	else: do_update_name = true
#endregion

#region Cursor Update/Dragging Functions
func on_area_mouse_entered() -> void:
	mouse_on_area = true
	if can_move:
		if not is_selected and not Global.is_selected:
			if Mouse.context == Mouse.CONTEXT.CURSOR:
				Mouse.set_context(Mouse.CONTEXT.SELECT)

func on_area_mouse_exited() -> void:
	mouse_on_area = false
	if can_move:
		if is_selected: snap_complete = true
		if not is_selected and not Global.is_selected:
			if Mouse.context == Mouse.CONTEXT.SELECT:
				Mouse.set_context(Mouse.CONTEXT.CURSOR)
	
func on_area_input_event(_viewport, _event, _shape_idx) -> void:
	if can_move:
		if Input.is_action_just_pressed("Click"):
			Mouse.set_context(Mouse.CONTEXT.GRAB)
			Mouse.set_mode(Mouse.MODE.CONFINED)
			z_index = 1
			is_selected = true
			Global.is_selected = true

# Do the dragging/ Move towards the current zone's center.
func _physics_process(delta):
	#region Dragging
	if is_selected:
		# Snap to cursor.
		if not snap_complete:
			if abs(global_position - get_global_mouse_position()) != GRAB_CURSOR_OFFSET:
				global_position = lerp(
					global_position,
					get_global_mouse_position() + GRAB_CURSOR_OFFSET,
					Global.snap_speed * delta
				)
			else: snap_complete = true
		
		# Drag piece towards the cursor:
		else:
			global_position = lerp(
				global_position,
				get_global_mouse_position() + GRAB_CURSOR_OFFSET,
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
		Global.is_selected = false
		snap_complete = false
		if mouse_on_area: Mouse.set_context(Mouse.CONTEXT.SELECT)
		else: Mouse.set_context(Mouse.CONTEXT.CURSOR)
		Mouse.set_mode(Mouse.MODE.FREE)
		if hovered_zone:
			if highlight_zone and Global.highlight_zone: 
				hovered_zone.invisible = true
		update_zone()
#endregion

#region Zone Functions
func assign_initial_zone() -> void:
	for zone: Dropzone in get_tree().get_nodes_in_group("Zone"):
		if global_position.distance_to(zone.global_position) < zone.radius:
			initial_zone = zone
			global_position = zone.global_position
			break
	current_zone = initial_zone

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
					if highlight_zone and Global.highlight_zone: 
						hovered_zone.invisible = true
				hovered_zone = zone
				
				if is_zone_valid(zone):
					return zone
	
	# Moving off a zone into a place with no zones -> make old one invisible.
	if hovered_zone:
		if highlight_zone and Global.highlight_zone: 
			hovered_zone.invisible = true
	hovered_zone = null
	
	return current_zone 

# Updates the piece's current zone to the selected zone. 
func update_zone(zone: Dropzone = nearest_zone()) -> void:
	current_zone = zone

func _process(_delta):
	if not Engine.is_editor_hint():
		#region Highlight Hovered Zone
		if is_selected:
			if highlight_zone and Global.highlight_zone:
				nearest_zone()
				if hovered_zone:
					if hovered_zone != current_zone:
						hovered_zone.invisible = false
		#endregion
		
		#region Cursor Update When Switching Turns
		if mouse_on_area and not Global.is_selected:
			if can_move and Global.turn_switched:
				if Mouse.context != Mouse.CONTEXT.SELECT:
					Mouse.set_context(Mouse.CONTEXT.SELECT)
					Global.turn_switched = false
			
			elif Global.turn_switched:
				if Mouse.context != Mouse.CONTEXT.CURSOR:
					Mouse.set_context(Mouse.CONTEXT.CURSOR)
					Global.turn_switched = false
		#endregion
#endregion
