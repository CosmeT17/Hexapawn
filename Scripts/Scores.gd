extends Node2D

@onready var AI_Score = $AI/Score
@onready var Player_Score = $Player/Score

func _ready():
	get_tree().get_root().get_child(0).update_scores.connect(update_scores)

func update_scores(entity: String, score: int) -> void:
	if entity == "AI": AI_Score.text = str(score)
	else: Player_Score.text = str(score)
