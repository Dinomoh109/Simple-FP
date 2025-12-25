extends CharacterBody3D

@export var speed := 6.0
@export var jump_force := 4.5
@export var mouse_sensitivity := 0.002

@onready var camera_pivot = $Camera_pivot

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var input_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var input_z = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	
	var direction = (transform.basis * Vector3(input_x, 0, input_z))
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
	
	move_and_slide()
	
func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		
		camera_pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		
		camera_pivot.rotation.x = clamp(
			camera_pivot.rotation.x,
			deg_to_rad(-80),
			deg_to_rad(80)
		)
