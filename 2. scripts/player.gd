extends CharacterBody3D

@export var speed: float = 6.0
@export var fall_acceleration = 75
@export var mouse_sensitivity := 0.002
@onready var camera = $CameraPivot/Camera3D
@onready var camera_pivot = $CameraPivot
@onready var ray = $CameraPivot/Camera3D/RayCast3D
var target_velocity = Vector3.ZERO


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$CanvasLayer/Label.visible = false
	$CameraPivot/Camera3D/paper.visible = false

func _physics_process(_delta):
	
	var direction = Vector3.ZERO
	label_visibility()
	
	if Input.is_action_pressed("move_right"):
		direction += camera.global_transform.basis.x
	if Input.is_action_pressed("move_left"):
		direction -= camera.global_transform.basis.x
	if Input.is_action_pressed("move_back"):
		direction += camera.global_transform.basis.z
	if Input.is_action_pressed("move_forward"):
		direction -= camera.global_transform.basis.z

	direction.y = 0

	if direction != Vector3.ZERO:
		direction = direction.normalized()

	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	velocity = target_velocity
	move_and_slide()
	sprint()
	note_on_screen()
	entering_house()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera_pivot.rotate_x(-event.relative.y * mouse_sensitivity)

		camera_pivot.rotation.x = clamp(
			camera_pivot.rotation.x,
			deg_to_rad(-89),
			deg_to_rad(89)
		)
		
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func sprint():
	if Input.is_action_pressed("sprint"):
		speed = 9
	else:
		speed = 6


func label_visibility():
	if $CameraPivot/Camera3D/RayCast3D.is_colliding():
		$CanvasLayer/Label.visible = true
	else: $CanvasLayer/Label.visible = false


func note_on_screen():
	
	if ray.is_colliding():
		var object = ray.get_collider()
		
		if object == $"../note/Cube/StaticBody3D":
			$CameraPivot/Camera3D/paper.visible = true
	else:
			$CameraPivot/Camera3D/paper.visible = false

func entering_house():
	
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider == $"../house/Cube_001/StaticBody3D":
			get_tree().change_scene_to_file("res://1. scenes/house_inside.tscn")
