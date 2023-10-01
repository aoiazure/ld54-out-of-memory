class_name CreditsMenu
extends Control

signal return_requested

@onready var button_return: Button = $ReturnButton

func _ready():
	button_return.pressed.connect(func(): return_requested.emit())




