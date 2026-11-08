extends Control

var full_size = Vector2i(1900, 1200)
func _on_resume_pressed() -> void:
	get_tree().paused = false
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_exit_pressed() -> void:
	get_tree().quit()

#for later
#func _on_resolution_full_pressed() -> void:
#	get_window().mode = Window.MODE_WINDOWED
#	get_window().size = full_size
#	print(full_size)
