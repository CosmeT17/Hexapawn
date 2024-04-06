extends Node2D
class_name Player

@onready var entities = get_parent()
@export var show_zone: bool = false

var winning_y: int # From grandparent --> grandchild
var can_move: bool = true # From parent --> child
var num_wins: int = 0

# From child --> parent
var is_white: bool
var is_turn: bool
#var is_AI: bool


func _ready():
	var pawn: Pawn = get_child(0)
	is_white = pawn.is_white
	is_turn = is_white
	
	#is_AI = pawn.is_AI
	

func turn_over():
	is_turn = false
	entities.turn_over(self.name)

func Game_Over():
	entities.game_over = true
	entities.Game_Over()
	num_wins += 1
	update_score()

func update_score():
	print("Player Won: %d" % num_wins)
