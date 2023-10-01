class_name MainMenu
extends MarginContainer

signal start_pressed
signal options_pressed
signal credits_pressed
signal exit_pressed

@onready var button_start : Button = $Center/Menu/StartButton
@onready var button_options : Button = $Center/Menu/OptionsButton
@onready var button_credits : Button = $Center/Menu/CreditsButton
@onready var button_exit : Button = $Center/Menu/ExitButton



func _ready():
	button_start.pressed.connect(func(): start_pressed.emit())
	button_options.pressed.connect(func(): options_pressed.emit())
	button_credits.pressed.connect(func(): credits_pressed.emit())
	button_exit.pressed.connect(func(): exit_pressed.emit())




