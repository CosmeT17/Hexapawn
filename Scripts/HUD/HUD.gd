extends Node2D

@export_global_file("*.png") var AI_pic = "res://Textures/HUD/Empty_Pic.png"
@export_global_file("*.png") var player_pic = "res://Textures/HUD/Empty_Pic.png"

func _ready():
	$Scores/AI/Picture.texture = load(AI_pic)
	$Scores/Player/Picture.texture = load(player_pic)
