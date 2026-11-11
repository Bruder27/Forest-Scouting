extends CharacterBody3D

@export var speed: float = 6.0
@export var fall_acceleration = 75
@export var mouse_sensitivity := 0.002
@onready var camera = $CameraPivot/Camera3D
@onready var camera_pivot = $CameraPivot
@onready var ray = $CameraPivot/Camera3D/RayCast3D
var target_velocity = Vector3.ZERO
@onready var default_fov = 75

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$CanvasLayer/E.visible = false
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
	zoom()
	todo_list()
	crouch()
	house_door_use()
	
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
	if $CameraPivot/Camera3D/paper.visible == false:
		if $CameraPivot/Camera3D/RayCast3D.is_colliding():
			$CanvasLayer/E.visible = true
		else: 
			$CanvasLayer/E.visible = false
	else: 
		$CanvasLayer/E.visible = false


func note_on_screen():
	if ray.is_colliding():
		var object = ray.get_collider()
		
		if object == $"../objects/note/Cube/StaticBody3D":
			if Input.is_action_pressed("press_e"):
				$CameraPivot/Camera3D/paper.visible = true
				$CameraPivot/Camera3D/paper/note_info.visible = true

	if not ray.is_colliding():
		if $CameraPivot/Camera3D/paper.visible == true:
			if Input.is_action_pressed("press_e"):
				$CameraPivot/Camera3D/paper.visible = false
				$CameraPivot/Camera3D/paper/note_info.visible = false


func entering_house():
	if ray.is_colliding():
		var collider = ray.get_collider()
		if Input.is_action_pressed("press_e"):
			if collider == $"../objects/house/Cube_001/StaticBody3D":
				get_tree().change_scene_to_file("res://1. scenes/house_inside.tscn")


func zoom():
	if Input.is_action_pressed("right_click"):
		$CameraPivot/Camera3D.fov = 45
	else:
		$CameraPivot/Camera3D.fov = default_fov

var objective_status = 0

func todo_list():
	if ray.is_colliding():
		var object = ray.get_collider()
		if objective_status == 0:
			if object == $"../objects/house/Cube_001/StaticBody3D":
				$hud/ToDo.text = "To do:
					- find note"
				objective_status += 1

		if object == $"../objects/note/Cube/StaticBody3D":
				$hud/ToDo.text = "To do
				- WHATS ON NOTE?"


func crouch():
	if Input.is_action_pressed("crouching"):
		$CameraPivot.position.y = -0.5
	else:
		$CameraPivot.position.y = 0


var open_door = false
func house_door_use():
	if ray.is_colliding():
		var object = ray.get_collider()
		if object == $"../objects/house_door_pivot/house_door/StaticBody3D":
			if  open_door == false:
				if Input.is_action_just_pressed("press_e"):
					open_door = true
					$"../objects/house_door_pivot".rotation.y = deg_to_rad(180)

			elif open_door:
				if Input.is_action_just_pressed("press_e"):
					open_door = false
					$"../objects/house_door_pivot".rotation.y = deg_to_rad(90)
