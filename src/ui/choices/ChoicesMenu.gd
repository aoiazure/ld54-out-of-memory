class_name ChoicesMenu
extends Control

signal choice_selected(data)
signal game_started
signal game_ended

@onready var choices_box: HSplitContainer = $Box/MarginContainer/Choices
@onready var choice_left: Choice = $Box/MarginContainer/Choices/ChoiceLeft
@onready var choice_right: Choice = $Box/MarginContainer/Choices/ChoiceRight

@onready var dialogue: Dialogue = $Box/DialoguePanel



func _ready():
	choice_left.choice_hovered.connect(_on_choice_hovered)
	choice_right.choice_hovered.connect(_on_choice_hovered)
	
	choice_left.choice_selected.connect(_on_left_selected)
	choice_right.choice_selected.connect(_on_right_selected)

func _on_choice_hovered(data: MemoryData) -> void:
	dialogue.set_dialogue(data.memory_description, false)



func start_game() -> void:
	choices_box.hide()
	await _starting_monologue()
	game_started.emit()
	choices_box.show()

func end_game(data: MemoryData) -> void:
	choices_box.hide()
	dialogue.show_speaker()
	await _ending_monologue(data)
	game_ended.emit()



func _on_left_selected(data: MemoryData) -> void:
	await choice_left.select()
	await choice_right.neglect()
	choice_selected.emit(data)

func _on_right_selected(data: MemoryData) -> void:
	await choice_right.select()
	await choice_left.neglect()
	choice_selected.emit(data)



func set_new_choices(d1: MemoryData, d2: MemoryData) -> void:
	choice_left.memory_data = d1
	choice_right.memory_data = d2
	choice_left.reset()
	choice_right.reset()




func _starting_monologue() -> void:
	dialogue = (dialogue as Dialogue)
	dialogue.set_speaker("Mind Remediation Co.")
	dialogue.show_speaker()
	await dialogue.set_dialogue("'Welcome, user.'")
	await dialogue.set_dialogue(
		"'Following a recent accident, you have been automatically enrolled "+
		"into Mind Remediation Co.'s Memory Defragmentation service.'")
	await dialogue.set_dialogue(
		"'Unfortunately, as a result of your incident, "+
		"your mental faculties are unable to maintain all memories of your life.'"
	)
	await dialogue.set_dialogue(
		"'In order to finish Memory Defragmentation, we request that you do a short survey.'"
	)
	await dialogue.set_dialogue("'We have identified five core memories of yours.'")
	await dialogue.set_dialogue(
		"'You will see two of them appear on screen. "+
		"Please evaluate which one you would rather maintain in your mind.'"
	)
	await dialogue.set_dialogue(
		"'Hovering over a memory will display an automatically generated "+
		"short but imprecise summary of that memory.'"
	)
	await dialogue.set_dialogue(
		"'Once we have acquired sufficient data, the survey will automatically conclude.'"
	)
	await dialogue.set_dialogue("'We look forward to previewing your one alloted memory to retain.'")
	await dialogue.set_dialogue("'Please click to proceed with the survey.'")
	await dialogue.set_dialogue("'...'")
	await dialogue.set_dialogue("'Loading survey. Survey now beginning.'")
	dialogue.hide_speaker()



func _ending_monologue(data: MemoryData) -> void:
	dialogue = (dialogue as Dialogue)
	await dialogue.set_dialogue("'Survey concluded.'")
	await dialogue.set_dialogue("'Thank you for selecting your desired memory to keep.'")
	await dialogue.set_dialogue("'Loading chosen memory for preview, please hold.'")
	await dialogue.set_dialogue("'...'")
	await dialogue.set_dialogue("'Memory loaded; now previewing.'")
	await dialogue.set_dialogue("'...'")
	
	await _show_memory(data)
	
	await dialogue.set_dialogue("'...'")
	await dialogue.set_dialogue("'Memory preview concluded.'")
	await dialogue.set_dialogue("'Thank you for participating in the Memory Defragmentation process.'")
	await dialogue.set_dialogue("'We hope you and your newly freed mind enjoy the rest of your day.'")
	await dialogue.set_dialogue("'The Mind Remediation Corporation looks forward to your next visit.'")

func _show_memory(data: MemoryData) -> void:
	var final_text: Array[String] = data.final_memory.duplicate()
	
	for text in final_text:
		await dialogue.set_dialogue(text)











