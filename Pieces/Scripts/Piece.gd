extends Sprite2D
class_name Piece

#region Constants
enum {WHITE, BLACK}
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
@onready var name_label = $Name_Label as Label
#endregion

#region Export Variables
@export_category("Customization")

@export_enum("White", "Black") var piece_color = 0 as int :
	set(color):
		piece_color = color
		match piece_color:
			WHITE: 
				if(name_label): name_label.theme = LABEL_WHITE_PIECE_THEME
			BLACK: 
				if(name_label): name_label.theme = LABEL_BLACK_PIECE_THEME

@export_enum("Blue", "Red") var eye_color = 0 as int

@export_enum("3x3 Board", "4x4 Board") var piece_size = 0 as int :
	set(size):
		piece_size = size
		scale = scale_amount[piece_size]
#endregion

func _ready():
	if not Engine.is_editor_hint():
		name_label.visible = false
	
	if piece_color == BLACK:
		name_label.theme = LABEL_BLACK_PIECE_THEME
