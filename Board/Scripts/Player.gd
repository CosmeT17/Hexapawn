@tool
extends Node
class_name Player

#region Constants and Variables
#region Constants
enum {WHITE, BLACK, UNTEXTURED}
enum {BLUE, RED}
#endregion

#region Variables
var is_ready: bool = false
var alter_other_player: bool = true

@onready var board = get_parent().get_parent() as Board
@onready var score_counter = $Score_Counter as ScoreCounter
@onready var pieces = $Pieces as Node2D

var num_pieces: int = -1 :
	set(num):
		num_pieces = num
		if not Engine.is_editor_hint() and num_pieces == 0:
			if not Global.game_over:
				Global.game_over = true
				set_variable(null, func(player: Player): player.game_won()) # All pieces captured.

var player_num : int = -1 : 
	set(num):
		player_num = num
		if player_num == 1: name = "Player_1"
		elif player_num == 2: name = "Player_2"
		if score_counter: score_counter.player_num = player_num

var is_turn: bool = true :
	set(val):
		if player_num != 0 and (is_turn != val or (not Engine.is_editor_hint() and Global.game_over)):
			if not (not Engine.is_editor_hint() and piece_color == UNTEXTURED):
				is_turn = val
				
				if not Engine.is_editor_hint(): 
					Global.update_cursor = true
				
				set_variable(
					func(piece: Piece): piece.can_move = is_turn and not is_ai if piece_color != UNTEXTURED else true,
					func(player: Player): player.is_turn = not is_turn if piece_color != UNTEXTURED else true
				)
				if score_counter: score_counter.is_turn = is_turn
#endregion

#region Export Variables
func set_variable(self_function, other_function, pre_run: bool = false) -> void:
	if is_ready or pre_run:
		if pieces and self_function:
			for piece in pieces.get_children():
				if piece is Piece:
					self_function.call(piece)
		
		if alter_other_player and other_function:
			for player in get_parent().get_children():
				if player is Player:
					if player != self:
						alter_other_player = false
						other_function.call(player)
		alter_other_player = true

#region Pieces Export Variables
@export_category("Pieces")
@export_enum("White", "Black", "Untextured") var piece_color: int = 2 :
	set(color):
		if player_num != 0 and piece_color != color:
			if color == UNTEXTURED and is_ai: is_ai = false 
			piece_color = color
			
			set_variable(
				func(piece: Piece): piece.piece_color = piece_color,
				func(player: Player):
					match piece_color:
						WHITE: player.piece_color = BLACK
						BLACK: player.piece_color = WHITE
						UNTEXTURED: player.piece_color = UNTEXTURED
			)
			if score_counter: update_profile_pic()
			
			if piece_color == BLACK: is_turn = false
			else: is_turn = true

@export var show_piece_ID: bool = false :
	set(val):
		if player_num != 0 and show_piece_ID != val:
			show_piece_ID = val
			
			set_variable(
				func(piece: Piece): piece.show_ID = show_piece_ID,
				func(player: Player): player.show_piece_ID = show_piece_ID
			)
#endregion

#region AI Export Variables
@export_category("AI")
@export var is_ai: bool = false :
	set(val):
		if (player_num == 2 and piece_color != UNTEXTURED and is_ai != val) or not is_ready:
			is_ai = val
			if not Engine.is_editor_hint(): Global.update_cursor = true
			
			set_variable(
				func(piece: Piece):
					if is_ai: 
						piece.eye_color = RED
						piece.highlight_zone = false
						piece.can_move = false
					else: 
						piece.eye_color = BLUE
						piece.highlight_zone = true
						if is_ready and is_turn: piece.can_move = true,
				null,
				true
			)
			if score_counter: update_profile_pic()

@export_range(-0.25, 1) var delay: float = 0 :
	set(val):
		if is_ai:
			if val < 0.0: delay = -0.25
			elif val < 0.25: delay = 0.0
			elif val < 0.5: delay = 0.25
			elif val < 0.75: delay = 0.50
			elif val < 1.0: delay = 0.75
			elif val == 1.0: delay = 1.0
#endregion
#endregion
#endregion

func _ready():
	player_num = 0
	is_ai = is_ai
	num_pieces = pieces.get_children().size()
	update_profile_pic()
	score_counter.is_turn = is_turn
	is_ready = true

func _on_pieces_child_entered_tree(node):
	if is_ready:
		if player_num != 0:
			if node is Piece:
				node.piece_color = piece_color
				node.show_ID = show_piece_ID
				node.piece_size = get_parent().get_parent().dimensions
				if piece_color == BLACK: node.can_move = false
				if is_ai: node.eye_color = RED
		else:
			node.queue_free()

func _to_string():
	const colors = {0: "WHITE", 1: "BLACK", 2: "UNTEXTURED"}
	const ai = {true: "IS_AI", false: "NOT_AI"}
	const turn = {true: "IS_TURN", false: "NOT_TURN"}
	
	var player_info: Array[String] = [
		colors[piece_color],
		ai[is_ai],
		turn[is_turn],
		"Num_Pieces: " + str(num_pieces)
	]
	
	return str(name) + ": " + str(player_info)

func update_profile_pic() -> void:
	match piece_color:
		WHITE: 
			if is_ai: score_counter.profile_pic = score_counter.WHITE_AI
			else: score_counter.profile_pic = score_counter.WHITE_PLAYER
		BLACK: 
			if is_ai: score_counter.profile_pic = score_counter.BLACK_AI
			else: score_counter.profile_pic = score_counter.BLACK_PLAYER
		UNTEXTURED: 
			score_counter.profile_pic = score_counter.NONE

func game_won() -> void:
	Global.game_over = true
	score_counter.game_won = true
	score_counter.score += 1

func reset() -> void:
	if piece_color == BLACK: is_turn = false
	else: is_turn = true
	for player: Player in get_parent().get_children():
		player.score_counter.game_won = false
		player.num_pieces = player.pieces.get_children().size()
		
var move: Array = []
var wait_input: bool = false
func ai_move_piece(start_of_game: bool = false) -> void:
	if not Engine.is_editor_hint():
		if is_ai and not Global.game_over:
			# Calculating Next Move
			move = Global.available_moves[board.board_id][board.board_state].pick_random()
			
			# AI Delay --> Wait before moving.
			if not start_of_game:
				await Global.piece_finished_moving
				await get_tree().create_timer(delay).timeout
			else: await get_tree().create_timer(0.5).timeout
			
			# TODO: FIXXX
			# Move piece after delay.
			#if delay >= 0: move[0].update_zone(move[1])
			#else: wait_input = true

func _input(_event):
	if wait_input:
		if Input.is_action_just_pressed("Alt_Click"):
			move[0].update_zone(move[1])
			wait_input = false
