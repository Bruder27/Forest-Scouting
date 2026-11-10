extends Control


func _on_resume_pressed() -> void:
	get_tree().paused = false
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_exit_pressed() -> void:
	get_tree().quit()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

#for later
#func _on_resolution_full_pressed() -> void:
#	get_window().mode = Window.MODE_WINDOWED
#	get_window().size = full_size
#	print(full_size)
