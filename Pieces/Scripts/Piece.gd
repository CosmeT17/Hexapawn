extends Node2D
class_name Piece

#region Constants
enum {WHITE, BLACK, UNTEXTURED}
enum {BLUE, RED}
enum {BOARD_3X3, BOARD_4X4}

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

const mouse_offset = Vector2(16, 0) as Vector2
#endregion

#region Children Variables
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

@export_enum("3x3 Board", "4x4 Board") var piece_size = 0 as int :
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

var movable: bool = true
var selected: bool = false
#endregion

func _ready():
	if not Engine.is_editor_hint():
		#name_label.visible = false
		pass
	
	update_texture()
	update_label()
	update_scale()

func set_textures(textures: Array[AtlasTexture]) -> void:
	piece_textures[[WHITE, BLUE]] = textures[0]
	piece_textures[[WHITE, RED]] = textures[1]
	piece_textures[[BLACK, BLUE]] = textures[2]
	piece_textures[[BLACK, RED]] = textures[3]
	piece_textures[UNTEXTURED] = textures[4]

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
