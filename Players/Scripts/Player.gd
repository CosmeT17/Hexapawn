@tool
extends Node
class_name Player

var can_set_player_num: bool = false
@export_enum("Player 1:1", "Player 2:2", "None: 0") var player_num: int = 1 :
	set(num):
		if can_set_player_num:
			player_num = num

#@export var is_AI: bool = false
#@export var is_turn: bool = false

# Pice:
# piece_color
# piece_eye_color
# show_piece_IDs

# Dropzones
# highlight_dropzones

# Internal
# move_direction
# winning_y
# num_wins

func _ready():
	pass
	#if Engine.is_editor_hint():
	#set_player_num()
	
	#if not Engine.is_editor_hint():
		#var players = get_tree().get_nodes_in_group("Player") as Array[Player]
		#if players.size() > 2 and self != players[0] and self != players[1]:
			#self.queue_free()

func set_player_num() -> void:
	# Use get_parent() instead of Group
	var players = get_tree().get_nodes_in_group("Player") as Array[Player]
	can_set_player_num = true
	
	for i: int in range(players.size()):
		if i == 1:
			player_num = 2
			name = "Player_2"
		
		elif i != 0:
			player_num = 0
			name = "Non_Player_" + str(i - 1)
	
	can_set_player_num = false
