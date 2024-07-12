extends Node2D
class_name Piece

#region Constants
enum {WHITE, BLACK, UNTEXTURED}
enum {BLUE, RED}
enum {BOARD_3X3, BOARD_4X4}

const LABEL_WHITE_PIECE_THEME = preload("res://Pieces/Themes/Label_White_Piece_Theme.tres") as Theme
const LABEL_BLACK_PIECE_THEME = preload("res://Pieces/Themes/Label_Black_Piece_Theme.tres") as Theme

const scale_amount = {
	BOARD_3X3: Vector2(1.0, 1.0),
	BOARD_4X4: Vector2(0.8, 0.8)
}
#endregion

#region Children Variables
@onready var sprite = $Sprite
@onready var name_label = $Name_Label as Label
#endregion

#region Export Variables
@export_category("Customization")

@export_enum("White", "Black", "Untextured") var piece_color = 2 as int :
	set(color):
		piece_color = color
		update_texture()
		match piece_color:
			WHITE: 
				if(name_label): 
					name_label.theme = LABEL_WHITE_PIECE_THEME
					name_label.text = 'W' + name_label.text.substr(1)
			BLACK: 
				if(name_label): 
					name_label.theme = LABEL_BLACK_PIECE_THEME
					name_label.text = 'B' + name_label.text.substr(1)
			UNTEXTURED:
				if(name_label):
					name_label.theme = LABEL_WHITE_PIECE_THEME
					name_label.text = '_' + name_label.text.substr(1)

@export_enum("Blue", "Red") var eye_color = 0 as int :
	set(color):
		eye_color = color
		update_texture()

@export_enum("3x3 Board", "4x4 Board") var piece_size = 0 as int :
	set(size):
		piece_size = size
		if(sprite): update_scale()
			
#endregion

#region Variables
var piece_textures = {
	[WHITE, BLUE]: null,
	[WHITE, RED]: null,
	[BLACK, BLUE]: null,
	[BLACK, RED]: null,
	UNTEXTURED: null
} as Dictionary
#endregion

func _ready():
	if not Engine.is_editor_hint():
		#name_label.visible = false
		pass
	
	if piece_color == BLACK:
		name_label.theme = LABEL_BLACK_PIECE_THEME
	
	update_texture()
	update_name_color()
	update_scale()

func set_textures(textures: Array[AtlasTexture]) -> void:
	piece_textures[[WHITE, BLUE]] = textures[0]
	piece_textures[[WHITE, RED]] = textures[1]
	piece_textures[[BLACK, BLUE]] = textures[2]
	piece_textures[[BLACK, RED]] = textures[3]
	piece_textures[UNTEXTURED] = textures[4]

func update_texture() -> void:
	if (sprite):
		if piece_color != UNTEXTURED: 
			sprite.texture = piece_textures[[piece_color, eye_color]]
		else: 
			sprite.texture = piece_textures[UNTEXTURED]
	
func update_name_color() -> void:
	match piece_color:
		WHITE: 
			name_label.text = 'W' + name_label.text.substr(1)
		BLACK: 
			name_label.text = 'B' + name_label.text.substr(1) 

func update_scale() -> void:
	sprite.scale = scale_amount[piece_size]
	# TO DO: Label scaling
