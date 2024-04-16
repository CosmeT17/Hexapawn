extends Node2D
class_name Player

@export var show_zone: bool = false
@onready var Entities = get_parent()
@onready var Pawns = get_children()

var winning_y: int # From grandparent --> grandchild
var can_move: bool = true # From parent --> child
var num_wins: int = 0

# From child --> parent
@onready var available_pawns: int = get_child_count()
@onready var max_pawns: int = available_pawns
var is_turn: bool = true: set = set_turn
var is_white: bool

# Possible moves per board state.
var moves: Dictionary = {}
var board_state: String = ""

func _ready():
	if max_pawns > 0:
		is_white = get_child(0).is_white
		if not is_white:
			is_turn = false

func turn_over():
	Entities.Grid.update_board_state()
	is_turn = false
	Entities.turn_over(self.name)

func Game_Over():
	Entities.Grid.update_board_state()
	Entities.Game_Over()
	num_wins += 1
	update_score()
	declare_winner()

func reset():
	if Entities.game_over:
		is_turn = is_white
		available_pawns = max_pawns

func update_score():
	Entities.Board.update_scores.emit("Player", num_wins)

func declare_winner():
	Entities.Board.toggle_border.emit("Player", "Winner")

func set_turn(val: bool):
	is_turn = val
	
	# Updating the moves hash table if never before seen board state.
	if is_turn and not Entities.game_over:
		board_state = Entities.Grid.board_state
		if  board_state not in moves:
			moves[board_state] = []
			for pawn in Pawns:
				if pawn.visible:
					for zone in pawn.possible_moves():
						if self is AI:
							moves[board_state].append([pawn, zone, 0])
						else:
							moves[board_state].append([pawn, zone])
		
		# Checking for a stalemate.
		if moves[board_state] == []:
			if self is AI: Entities.player.Game_Over()
			else: Entities.AI.Game_Over()
		
		## TESTING
		print('[' + name + '] ' + board_state + ': ' + str(moves[board_state]))
