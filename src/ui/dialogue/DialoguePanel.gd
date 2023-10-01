class_name Dialogue
extends PanelContainer

signal tween_finished
signal go_next

@onready var speaker: Label = $Margins/Vertical/Speaker
@onready var text: Label = $Margins/Vertical/Dialogue
@onready var sep: HSeparator = $Margins/Vertical/HSeparator
@onready var button: Button = $Button

var tween: Tween

func _ready():
	button.pressed.connect(_on_pressed)
	hide_speaker()





func show_speaker() -> void:
	speaker.show()
	sep.show()

func hide_speaker() -> void:
	speaker.hide()
	sep.hide()

func set_speaker(_text: String) -> Dialogue:
	speaker.text = _text
	return self

## Sets the appropriate text in the textbox for display.
func set_dialogue(_text: String, do_tween: bool = true) -> void:
	text.text = _text
	if do_tween:
		tween_dialogue()
	await go_next
	SoundManager.play_sound("res://assets/sfx/BlipUp.wav")

## Animate the dialogue popping up.
func tween_dialogue() -> Dialogue:
	text.visible_ratio = 0.0
	tween = create_tween()
	var tween_length: float = (text.text.length()) / 15.0
	tween.tween_property(text, "visible_ratio", 1.0, tween_length)
	tween.play()
	tween.finished.connect(func(): tween_finished.emit())
	return self

## Called when the Dialogue is pressed.
func _on_pressed() -> void:
	if tween.is_running():
		tween.stop()
		text.visible_ratio = 1.0
		tween_finished.emit()
	else:
		go_next.emit()









