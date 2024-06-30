class_name Menu
extends Control

@onready var main_menu = $Main_Menu as MainMenu
@onready var play_menu = $Play_Menu as PlayMenu
@onready var options_menu = $Options_Menu as OptionsMenu
@onready var game = preload("res://Main.tscn").instantiate() as Main

func _ready():
	main_menu.enter_menu()
	handle_connecting_signals()


#region Main_Menu Functions
func enter_play_menu() -> void:
	main_menu.exit_menu()
	play_menu.enter_menu()

func enter_options_menu() -> void:
	main_menu.exit_menu()
	options_menu.enter_menu()
#endregion


#region Play_Menu Functions
func start_game(board_type: int) -> void:
	game.start_board = board_type
	get_tree().root.add_child(game)
	get_tree().root.remove_child(self)
	self.queue_free()

func start_3x3_board() -> void:
	start_game(game.BOARD_3X3)

func start_4x4_board() -> void:
	start_game(game.BOARD_4X4)
	
func exit_play_menu() -> void:
	play_menu.exit_menu()
	main_menu.enter_menu()
#endregion


#region Options_Menu Functions
func exit_options_menu() -> void:
	options_menu.exit_menu()
	main_menu.enter_menu()
#endregion


func handle_connecting_signals() -> void:
	#region Main_Menu Signals
	main_menu.enter_play_menu.connect(enter_play_menu)
	main_menu.enter_options_menu.connect(enter_options_menu)
	#endregion
	
	#region Play_Menu Signals
	play_menu.start_3x3_board.connect(start_3x3_board)
	play_menu.start_4x4_board.connect(start_4x4_board)
	play_menu.exit_play_menu.connect(exit_play_menu)
	#endregion
	
	#region Options_Menu Signals
	options_menu.exit_options_menu.connect(exit_options_menu)
	#endregion
