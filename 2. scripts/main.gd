extends Node3D

@onready var pause_menu = $PauseMenu

func _ready() -> void:
	pause_menu.visible = false


func _process(_delta: float) -> void: 
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()


func toggle_pause() -> void:
	get_tree().paused = !get_tree().paused
	pause_menu.visible = get_tree().paused

	if get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
