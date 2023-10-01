class_name Choice
extends Control

signal choice_hovered(data)
signal choice_selected(data)

const HOVER_SOUNDS: Array[String] = [
	"res://assets/sfx/select/Select1.wav",
	"res://assets/sfx/select/Select2.wav", 
	"res://assets/sfx/select/Select3.wav", 
	"res://assets/sfx/select/Select4.wav"
]

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var bg_cloud: Panel = $CloudBG
@onready var body: VBoxContainer = $Margins/Body
@onready var icon_memory: TextureRect = $Margins/Body/MemoryIcon
@onready var label_memory: Label = $Margins/Body/MemoryLabel

var memory_data: MemoryData : set = _set_memory_data

var finished: bool = false
var is_hovered: bool = false

func _ready():
	mouse_entered.connect(_on_choice_hovered)
	mouse_exited.connect(_on_choice_dehovered)
	resized.connect(_on_resized)


func _set_memory_data(value: MemoryData) -> void:
	memory_data = value
	if memory_data.memory_icon:
		icon_memory.texture = memory_data.memory_icon
	label_memory.text = memory_data.memory_name



func reset() -> void:
	_on_resized()
	bg_cloud.scale = Vector2.ONE
	bg_cloud.rotation_degrees = 0
	is_hovered = false
	finished = false
	body.show()


# Do animation for the choice being selected
func select() -> void:
	SoundManager.play_sound("res://assets/sfx/BlipUp.wav")
	is_hovered = false
	anim.play("Select")
	body.hide()
	await anim.animation_finished

func neglect() -> void:
	SoundManager.play_sound("res://assets/sfx/BlipDown.wav")
	is_hovered = false
	anim.play("Neglect")
	body.hide()
	await anim.animation_finished



func _input(_event):
	if Input.is_action_pressed("select") and is_hovered:
		choice_selected.emit(memory_data)
		finished = true


func _on_choice_hovered() -> void:
	if finished:
		return
	
	if not anim.is_playing():
		SoundManager.play_sound(HOVER_SOUNDS[randi_range(0, HOVER_SOUNDS.size() - 1)])
	anim.play("Hover")
	is_hovered = true
	choice_hovered.emit(memory_data)

func _on_choice_dehovered() -> void:
	if finished:
		return
	anim.play("Dehover")
	is_hovered = false



func _on_resized() -> void:
	bg_cloud.pivot_offset = bg_cloud.size/2









