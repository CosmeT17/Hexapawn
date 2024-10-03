@tool
extends Node
class_name Board

#region Variables and Constants
#region Textures
const BOARD_3X3_TEXTURE = preload("res://Board/Textures/Board/Board_3x3_Texture.png") as AtlasTexture
const BOARD_4X4_TEXTURE = preload("res://Board/Textures/Board/Board_4x4_Texture.png") as AtlasTexture
const BOARD_DEFAULT_TEXTURE = preload("res://Board/Textures/Board/Board_Default_Texture.png") as AtlasTexture
const board_textures: Dictionary = {
	Global.BOARD_3X3: BOARD_3X3_TEXTURE,
	Global.BOARD_4X4: BOARD_4X4_TEXTURE,
	Global.NONE: BOARD_DEFAULT_TEXTURE
}
#endregion

#region Children Variables
@onready var sprite = $Sprite as Sprite2D
@onready var grid = $Grid as Grid
@onready var player_1 = $Players/Player_1 as Player
@onready var player_2 = $Players/Player_2 as Player
#endregion

#region Export Variables
@export_enum("3x3:3", "4x4:4", "None:0") var dimensions: int = 0 :
	set(dim):
		if dimensions != dim and dim in [3, 4, 0]:
			dimensions = dim
			update_board()

#region Dropzone Export Variables
@export_category("Dropzones")
@export var highlight_dropzones: bool = false :
	set(val):
		if highlight_dropzones != val:
			highlight_dropzones = val
			if not Engine.is_editor_hint():
				Global.highlight_zone = false if show_dropzones else highlight_dropzones

@export var show_zone_ID: bool = false :
	set(val):
		if show_zone_ID != val:
			show_zone_ID = val
			if grid: grid.show_dropzone_ID = show_zone_ID
#endregion

@export var show_dropzones: bool = false :
	set(val):
		if show_dropzones != val:
			show_dropzones = val
			if grid: grid.show_dropzones = show_dropzones
#endregion

#region Variables
signal tie_detection_complete
var game_start: bool = true
var is_tie: bool = false

var board_id: int = -1 :
	set(val):
		board_id = val
		
		if board_id != -1:
			if board_id not in Global.avilable_moves:
				Global.avilable_moves[board_id] = {} as Dictionary
	
var board_state: String :
	set(val):
		print("Updating Board State")
		board_state = val
		
		var available_moves
		if board_id in Global.avilable_moves: 
			available_moves = Global.avilable_moves[board_id] as Dictionary
		
		#region Calculating Possible Moves
		if available_moves != null:
			if board_state not in available_moves:
				if not Global.game_over:
					available_moves[board_state] = []
					
					var player: Player = player_1 if player_1.is_turn else player_2
					for piece: Piece in player.pieces.get_children():
						var moves = piece.get_moves()
						
						for zone in moves:
							available_moves[board_state].append([piece, zone])
		#endregion
		
		#region Detecting Ties
		if not Global.game_over:
			if available_moves[board_state] == []:
				is_tie = true
				
				if player_1.is_turn:
					player_1.score_counter.is_turn = false
					player_2.game_won()
				else:
					player_2.score_counter.is_turn = false
					player_1.game_won()
			
		await get_tree().create_timer(3).timeout
		
		
				
		if not game_start:
			print("\nEmit\n")
			tie_detection_complete.emit()
			#endregion
		game_start = false
#endregion
#endregion

func _ready():
	#region Initializing Export Variables
	update_board()
	grid.show_dropzone_ID = show_zone_ID
	grid.show_dropzones = show_dropzones
	if not Engine.is_editor_hint():
			Global.highlight_zone = false if show_dropzones else highlight_dropzones
			Global.zones_generated.emit()
	#endregion
	
	player_1.player_num = 1
	player_2.player_num = 2
	
	#region Calculating Board_ID and Board_State
	var string_id: String = ""
	for piece: Piece in get_tree().get_nodes_in_group("Piece"):
		string_id += str(piece.name)
		
	board_id = string_id.hash()
	
	update_board_state()
	#endregion

func update_board() -> void:
	if sprite: sprite.texture = board_textures[dimensions]
	if grid: grid.dimensions = dimensions

func update_board_state() -> void:
	var state = player_1.piece_color if player_1.is_turn else player_2.piece_color
	state = "W:" if state == Global.WHITE else "B:"
	
	if not Global.game_over:
		for piece: Piece in get_tree().get_nodes_in_group("Piece"):
			if piece.current_zone: state += piece.current_zone.char_ID
			else: state += "_"
	else: state += "GAME_OVER"
		
	board_state = state

func switch_turns() -> void:
	print("Switch Turns")
	
	if Mouse.context != Mouse.CONTEXT.CURSOR: Mouse.set_context(Mouse.CONTEXT.CURSOR)
	Global.num_pieces_mouse_on_area = 0
	Global.can_move = false
	
	await tie_detection_complete
	
	if not Global.game_over and not game_start:
		player_1.is_turn = not player_1.is_turn
		Global.can_move = true

func _to_string():
	var out: String = str(name) 
	out += " (" + str(board_id) 
	out += "::" + board_state
	
	if Global.game_over and board_state != "GAME_OVER":
		out += " --> TIE"
	
	out += "):\n\n"
	out += "\t* " + str(player_1) + "\n"
	out += "\t* " + str(player_2) + "\n\n"
	
	out += "\t"
	for chr: String in str(grid):
		if chr == "\n": out += "\n\t"
		else: out += chr
	
	return out

var count = 0
func _input(_event):
	# Restart Game
	if Global.game_over and Global.can_restart and Input.is_action_just_pressed("Alt_Click"):
		print("Restart")
		game_start = true
		
		await tie_detection_complete
		
		for piece: Piece in get_tree().get_nodes_in_group("Piece"):
			piece.reset()
		player_1.reset()
		
		Global.game_over = false
		is_tie = false
		update_board_state()
		Global.can_move = true

# ------------------------------------------------------------------------------
	# TESTING
	if Input.is_action_just_pressed("Test"):
		player_1.is_turn = not player_1.is_turn
	
	elif Input.is_action_just_pressed("Print_Moves"):
		print(board_id, "::", board_state)
		print(Global.avilable_moves_to_string())
		print()
	
	elif Input.is_action_just_pressed("Print_Board"):
		print(_to_string())
		print()
		
		#print("\nPawn: initial_zone, current_zone, nearest_zone, hovered_zone")
		#for player: Player in [player_1, player_2]:
			#for pawn: Pawn in player.get_node("Pieces").get_children():
				#var zones: Array = [pawn.initial_zone, pawn.current_zone, pawn.nearest_zone, pawn.hovered_zone]
				#
				#for i in range(zones.size()):
					#if zones[i]: zones[i] = zones[i].ID
					#else: zones[i] = "__"
					#
				#print("\t* ", pawn, ": ", zones)
			#print()
		
	elif Input.is_action_just_pressed("Change_Piece_Color"):
		if player_1.piece_color == Global.WHITE:
			player_1.piece_color = Global.BLACK
		else:
			player_1.piece_color = Global.WHITE
	
	elif Input.is_action_just_pressed("Toggle_AI"):
		player_2.is_ai = not player_2.is_ai
	
	elif Input.is_action_just_pressed("Toggle_Piece_ID"):
		player_1.show_piece_ID = not player_1.show_piece_ID

	elif Input.is_action_just_pressed("Toggle_Grid_ID"):
		show_zone_ID = not show_zone_ID
	
	elif Input.is_action_just_pressed("Capture_Piece"):
		#player_2.get_node("Pieces").get_children()[1].update_zone(grid.dropzones[1][1])
		
		if player_2.is_turn:
			if count == 0:
				player_2.get_node("Pieces").get_children()[1].update_zone(grid.dropzones[1][0])
				count += 1
			
			else: 
				#player_2.get_node("Pieces").get_children()[1].update_zone(grid.dropzones[0][1])
				player_2.get_node("Pieces").get_children()[1].update_zone(grid.dropzones[0][1])
				count = 0




# ERASE
#func _process(_delta):
	#if not Engine.is_editor_hint():
		#if game_start:
			#print("true")
