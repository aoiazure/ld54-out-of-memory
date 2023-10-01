class_name Game
extends Control

@onready var main_menu: MainMenu = $Menu
@onready var game_menu: ChoicesMenu = $ChoicesMenu
@onready var cred_menu: CreditsMenu = $CreditsMenu

const MEMORY_BANK: Array[MemoryData] = [
	preload("res://assets/memory_data/MemoryBday.tres"),
	preload("res://assets/memory_data/MemoryDistance.tres"),
	preload("res://assets/memory_data/MemoryFuneral.tres"),
	preload("res://assets/memory_data/MemoryMeeting.tres"),
	preload("res://assets/memory_data/MemoryWedding.tres"),
]

var NUMBER_OF_ROUNDS: int = 10 : 
	set(_v): NUMBER_OF_ROUNDS = matchups.size()

var number_voted: int = 0
var memory_stats: Dictionary = {}

var matchups: Array[Array] = [
	[0, 1], [0, 2], [0, 3], [0, 4],
	[1, 2], [1, 3], [1, 4],
	[2, 3], [2, 4],
	[3, 4],
]


func _ready():
	main_menu.show()
	game_menu.hide()
	
	main_menu.start_pressed.connect(_start_game)
	main_menu.credits_pressed.connect(_on_credits_selected)
	main_menu.exit_pressed.connect(_exit_game)
	
	game_menu.choice_selected.connect(_on_choice_selected)
	game_menu.game_ended.connect(_end_game)
	
	cred_menu.return_requested.connect(_on_credits_return)

func set_up_match() -> void:
	var i: int = randi_range(0, matchups.size() - 1)
	var a: Array = matchups.pop_at(i)
	game_menu.set_new_choices(MEMORY_BANK[a[0]], MEMORY_BANK[a[1]])



func _start_game() -> void:
	main_menu.hide()
	game_menu.show()
	SoundManager.play_sound("res://assets/sfx/BlipUp.wav")
	game_menu.start_game()
	await game_menu.game_started
	set_up_match()

func _end_game() -> void:
	game_menu.hide()
	main_menu.hide()
	_on_credits_selected()

func _exit_game() -> void:
	get_tree().quit()



func _on_choice_selected(data: MemoryData) -> void:
	# Make the vote
	var memory_name: String = data.memory_name
	if memory_stats.keys().has(memory_name):
		memory_stats[memory_name] += 1
	else:
		memory_stats[memory_name] = 1
	number_voted += 1
	
	if number_voted < NUMBER_OF_ROUNDS:
		set_up_match()
	else:
		var tied: int = _check_ties()
		if tied > 0:
			var highest: MemoryData
			for d in MEMORY_BANK:
				if d.memory_name == _get_highest_vote():
					highest = d
			game_menu.end_game(highest)
			return
		
		perform_tiebreaker(tied)


func _check_ties() -> int:
	var has_tie: bool = false
	var highest: int = -1
	
	for key in memory_stats.keys():
		var value: int = memory_stats[key]
		if value > highest:
			highest = value
		if value == highest:
			has_tie = true
			break
	
	return highest if has_tie else -1

func perform_tiebreaker(tie: int) -> void:
	var tied_1: String 
	var tied_2: String
	
	for key in memory_stats.keys():
		var value: int = memory_stats[key]
		if value == tie:
			if tied_1.is_empty(): 
				tied_1 = key
				continue
			else: 
				tied_2 = key
				break
	
	var data1: MemoryData
	var data2: MemoryData
	
	for data in MEMORY_BANK:
		if data.memory_name == tied_1:
			data1 = data
		elif data.memory_name == tied_2:
			data2 = data
	
	if (not data1) or (not data2):
		push_error("ERROR: Tie not able to be broken!")
		return
	
	game_menu.set_new_choices(data1, data2)

func _get_highest_vote() -> String:
	var highest: int = -1
	var key_highest: String
	
	for key in memory_stats.keys():
		var value: int = memory_stats[key]
		if value > highest:
			key_highest = key
			highest = value
	
	return key_highest

func _on_credits_selected() -> void:
	main_menu.hide()
	game_menu.hide()
	cred_menu.show()

func _on_credits_return() -> void:
	cred_menu.hide()
	main_menu.show()




