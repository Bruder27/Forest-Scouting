extends Node3D

@onready var pause_menu = $CanvasLayer/PauseMenu

func _ready():
	pause_menu.visible = false

@warning_ignore("unused_parameter")
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()
	
func toggle_pause():
	get_tree().paused = !get_tree().paused
	pause_menu.visible = get_tree().paused
