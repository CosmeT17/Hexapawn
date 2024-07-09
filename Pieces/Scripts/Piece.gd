extends Sprite2D
class_name Piece

const LABEL_BLACK_PIECE = preload("res://Pieces/Themes/Label_Black_Piece.tres")
enum {WHITE, BLACK}

@export_category("Customization")
@export_enum("White", "Black") var piece_color = 0 as int

@onready var name_label = $Name_Label as Label

func _ready():
	if piece_color == BLACK:
		name_label.theme = LABEL_BLACK_PIECE
