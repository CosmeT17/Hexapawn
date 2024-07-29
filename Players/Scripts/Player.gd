@tool
extends Node
class_name Player

var change_player_nums: bool = true

@export_enum("Player 1:1", "Player 2:2") var player_num: int = 1 :
	set(num):
		player_num = num
		#if not change_player_nums:
			#player_num = num
		#else:
			#for player: Player in get_tree().get_nodes_in_group("Player"):
				#if player == self: 
					#player_num = num
				#else:
					#player.change_player_nums = false 
					#if player_num == 1: player.player_num = 2
					#else: player.player_num = 1
					#player.change_player_nums = true
		
		update_player_num()


@export var is_AI: bool = false
@export var is_turn: bool = false

var num_direction

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
	#var players: Array = get_tree().get_nodes_in_group("Player")
	#print(players)
	
	update_player_num()

func update_player_num() -> void:
	match player_num:
		1: name = "Player_1"
		2: name = "Player_2"
		
	if not Engine.is_editor_hint():
		match player_num:
			1: num_direction = Global.UP
			2: num_direction = Global.DOWN
