extends Node2D
class_name Player

@onready var entities = get_parent()
@export var show_zone: bool = false

signal end_game
var num_wins: int = 0

# From grandparent --> grandchild
var winning_y: int

# From parent --> child
var can_move: bool = true

# From child --> parent
var is_AI: bool
var is_white: bool
var is_turn: bool

func _ready():
	end_game.connect(Game_Over)
	var pawn: Pawn = get_child(0)
	is_AI = pawn.is_AI
	is_white = pawn.is_white
	is_turn = is_white

func Game_Over():
	entities.game_over = true
	entities.Game_Over()
	num_wins += 1
	update_score()

func update_score():
	print("Player Won: %d" % num_wins)
