extends Node2D
class_name Player

@onready var entities = get_parent()
@export var show_zone: bool = false

var winning_y: int # From grandparent --> grandchild
var can_move: bool = true # From parent --> child
var num_wins: int = 0

# From child --> parent
@onready var available_pawns: int = get_child_count()
@onready var max_pawns: int = available_pawns
var is_white: bool
var is_turn: bool

func _ready():
	if max_pawns > 0:
		is_white = get_child(0).is_white
		is_turn = is_white
	
	print(self)
	print(is_turn)
	print()

func turn_over():
	is_turn = false
	entities.turn_over(self.name)

func Game_Over():
	entities.game_over = true
	entities.Game_Over()
	num_wins += 1
	update_score()

func reset():
	is_turn = is_white
	available_pawns = max_pawns

func update_score():
	print("Player Won: %d" % num_wins)
