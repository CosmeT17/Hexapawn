@tool
extends Node2D
class_name Game

const TEST = preload("res://Game/Scenes/Test.tscn") as PackedScene # TESTING

enum {HEXAPAWN_3X3, HEXAPAWN_4x4}
const SCENE_HEXAPAWN_3X3 = preload("res://Game_Boards/Scenes/Hexapawn_3x3.tscn") as PackedScene
const SCENE_HEXAPAWN_4X4 = preload("res://Game_Boards/Scenes/Hexapawn_4x4.tscn") as PackedScene

@export_enum("Hexapawn_3X3", "Hexapawn_4X4", "TEST") var game_mode: int = 0 :
	set(val):
		if val != game_mode and val in range(3): # TEST
			game_mode = val
			match game_mode:
				HEXAPAWN_3X3: board = SCENE_HEXAPAWN_3X3.instantiate()
				HEXAPAWN_4x4: board = SCENE_HEXAPAWN_4X4.instantiate()
			
			if not Engine.is_editor_hint():
				if is_ready:
					board_container.get_child(0).queue_free()
			elif board_container:
				for child in board_container.get_children(): child.free()
				if game_mode != 2: # TEST
					board_container.add_child(board)
				else: # TEST
					board_container.add_child(TEST.instantiate())

@onready var board_container = $Canvas/Board_Container as HBoxContainer
var board: BoardController
var in_game: bool = false
var is_ready: bool = false

func _ready():
	in_game = true
	
	if game_mode != 2: # TEST
		if not Engine.is_editor_hint():
			Global.zones_destroyed.connect(
				func():
					if in_game: board_container.add_child.call_deferred(board)
			)
		
		if game_mode == HEXAPAWN_3X3: board = SCENE_HEXAPAWN_3X3.instantiate()
		board_container.add_child(board)
		
	else: # TEST
		board_container.add_child(TEST.instantiate())
	
	is_ready = true

func exit_to_main_menu() -> void:
	in_game = false
	is_ready = false
	if game_mode != 2: # TEST
		board.queue_free()
	get_tree().root.remove_child(self)

func _input(_event):
	if Input.is_action_just_pressed("Test"): # Middle_Mouse_Button
		#print(board_container.get_children())
		pass
	
	if Input.is_action_just_pressed("Print_Tree"): # T
		print_tree_pretty()
	
	if Input.is_action_just_pressed("Load_Hexapawn_3X3"): # 3
		if game_mode != 2: # TEST
			game_mode = HEXAPAWN_3X3
	
	if Input.is_action_just_pressed("Load_Hexapawn_4X4"): # 4
		if game_mode != 2: # TEST
			game_mode = HEXAPAWN_4x4
	
	# Exit to main menu
	if Input.is_action_just_pressed("Exit"): # ESC
		exit_to_main_menu()
