extends Node2D

@export_global_file("*.png") var AI_pic = ""
@export_global_file("*.png") var player_pic = ""

@onready var AI_Score = $AI/Score
@onready var Player_Score = $Player/Score

@onready var AI_Border_Select = $AI/Border_Select
@onready var Player_Border_Select = $Player/Border_Select

@onready var AI_Border_Winner = $AI/Border_Winner
@onready var Player_Border_Winner = $Player/Border_Winner

func _ready():
	#print(get_tree().get_root().get_path())
	
	if AI_pic != "": $AI/Picture.texture = load(AI_pic)
	if player_pic != "": $Player/Picture.texture = load(player_pic)
	
	get_parent().update_scores.connect(update_scores)
	get_parent().toggle_border.connect(toggle_border)

func update_scores(entity: String, score: int) -> void:
	if entity == "AI": AI_Score.text = str(score)
	else: Player_Score.text = str(score)

func toggle_border(entity: String = "", border: String = "Select") -> void:
	var AI_Border = AI_Border_Select if border == "Select" else AI_Border_Winner
	var Player_Border = Player_Border_Select if border == "Select" else Player_Border_Winner
	
	match entity:
		"AI":
			AI_Border.visible = true
			Player_Border.visible = false
		"Player":
			AI_Border.visible = false
			Player_Border.visible = true
		_:
			AI_Border.visible = false
			Player_Border.visible = false
