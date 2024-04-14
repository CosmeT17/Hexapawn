extends Node2D
class_name Player

@export var show_zone: bool = false
@onready var Entities = get_parent()
@onready var Grid = get_parent().get_parent()

var winning_y: int # From grandparent --> grandchild
var can_move: bool = true # From parent --> child
var num_wins: int = 0

# From child --> parent
@onready var available_pawns: int = get_child_count()
@onready var max_pawns: int = available_pawns
var is_turn: bool: set = set_turn
var is_white: bool

func _ready():
	if max_pawns > 0:
		is_white = get_child(0).is_white
		is_turn = is_white

func turn_over():
	Grid.update_board_state()
	is_turn = false
	Entities.turn_over(self.name)

func Game_Over():
	Entities.game_over = true
	Entities.Game_Over()
	num_wins += 1
	update_score()
	declare_winner()

func reset():
	is_turn = is_white
	available_pawns = max_pawns

func update_score():
	Entities.Board.update_scores.emit("Player", num_wins)

func declare_winner():
	Entities.Board.toggle_border.emit("Player", "Winner")

func set_turn(val: bool):
	is_turn = val
