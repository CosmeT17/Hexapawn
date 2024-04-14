extends Node2D

signal update_scores(entity: String, score: int)
signal toggle_border(entity: String, border: String)

func _ready():
	if $Sprite/Grid/Entities/AI.is_turn: $Scores.toggle_border("AI")
	else: $Scores.toggle_border("Player")
