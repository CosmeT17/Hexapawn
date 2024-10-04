@tool
extends Node2D
class_name ScoreCounter

enum {NONE, WHITE_PLAYER, BLACK_PLAYER, WHITE_AI, BLACK_AI}

const EMPTY_PROFILE_PIC = preload("res://Board/Textures/Profile_Pics/Empty_Profile_Pic.png") as AtlasTexture
const PAWN_BLACK_BLUE_PROFILE_PIC = preload("res://Board/Textures/Profile_Pics/Pawn_Black_Blue_Profile_Pic.png") as  AtlasTexture
const PAWN_BLACK_RED_PROFILE_PIC = preload("res://Board/Textures/Profile_Pics/Pawn_Black_Red_Profile_Pic.png") as  AtlasTexture
const PAWN_WHITE_BLUE_PROFILE_PIC = preload("res://Board/Textures/Profile_Pics/Pawn_White_Blue_Profile_Pic.png") as  AtlasTexture
const PAWN_WHITE_RED_PROFILE_PIC = preload("res://Board/Textures/Profile_Pics/Pawn_White_Red_Profile_Pic.png") as  AtlasTexture

const profile_pic_textures: Array[AtlasTexture] = [
	EMPTY_PROFILE_PIC,
	PAWN_WHITE_BLUE_PROFILE_PIC,
	PAWN_BLACK_BLUE_PROFILE_PIC,
	PAWN_WHITE_RED_PROFILE_PIC,
	PAWN_BLACK_RED_PROFILE_PIC
]

@onready var profile_pic_sprite = $Profile_Pic as Sprite2D
@onready var border_green = $Border_Green as Sprite2D
@onready var border_red = $Border_Red as Sprite2D
@onready var label_name = $Label_Name as Label
@onready var label_score = $Label_Score as Label

@export_enum("None", "White_Player", "Black_Player", "White_AI", "Black_AI")
var profile_pic : int = 0 :
	set(val):
		profile_pic = val
		set_profile_pic()

@export var player_num: int = 1 :
	set(num):
		if num in [1, 2]:
			player_num = num
			set_player_num()

var score: int = 0 :
	set(num):
		score = num
		if label_score: label_score.text = str(score)

var is_turn: bool = false :
	set(val):
		is_turn = val
		if border_green: border_green.visible = is_turn

var game_won: bool = false :
	set(val):
		if game_won != val:
			game_won = val
			if border_red: border_red.visible = game_won

var window_size: Vector2

func _ready():
	set_profile_pic()
	set_player_num()
	
	get_tree().get_root().size_changed.connect(update_position)
	window_size = get_viewport().get_visible_rect().size

func update_position() -> void:
	if not Engine.is_editor_hint():
		var new_window_size = get_viewport().get_visible_rect().size
		global_position.x += (new_window_size.x - window_size.x) / 2
		window_size = new_window_size

func set_profile_pic() -> void:
	if profile_pic_sprite: 
		profile_pic_sprite.texture = profile_pic_textures[profile_pic]
	
		if label_name:
			if profile_pic == NONE: label_name.text = "Name"
			elif profile_pic < WHITE_AI: 
				if player_num == 1: label_name.text = "Player 1"
				else: label_name.text = "Player 2"
			else: label_name.text = "Machine"

func set_player_num() -> void:
	if label_name:
		if player_num == 1:
			label_name.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
			label_name.position = Vector2(
				-label_name.size.x / 2, 
				-profile_pic_sprite.texture.get_height() 
				* profile_pic_sprite.scale.y / 2
				- label_name.size.y
			)
			if profile_pic != NONE and profile_pic < WHITE_AI: 
				label_name.text = "Player 1"
		else:
			label_name.vertical_alignment = VERTICAL_ALIGNMENT_TOP
			label_name.position = Vector2(
				-label_name.size.x / 2, 
				profile_pic_sprite.texture.get_height() 
				* profile_pic_sprite.scale.y / 2 - 5
			)
			if profile_pic != NONE and profile_pic < WHITE_AI: 
				label_name.text = "Player 2"
