extends CharacterBody3D

signal set_movement_state(_movement_state: MovementState)
signal set_movement_direction(_movement_direction: Vector3)
signal pressed_jump()
signal health_changed(health_value)

@export var movement_states: Dictionary

var movement_direction: Vector3
var health: int = 10

@onready var camera = $CamRoot/CamYaw/CamPitch/SpringArm3D/Camera3D

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	if not is_multiplayer_authority(): return
	set_movement_state.emit(movement_states["stand"])
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.current = true

func _physics_process(_delta):
	if not is_multiplayer_authority(): return
	var input_dir = Input.get_vector("left", "right", "up", "down")
	movement_direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if movement_direction:
		set_movement_direction.emit(movement_direction)
		if Input.is_action_pressed("run"):
			set_movement_state.emit(movement_states["run"])
		elif Input.is_action_pressed("crouch"):
			set_movement_state.emit(movement_states["crouch"])
		else:
			set_movement_state.emit(movement_states["walk"])
	else:
		set_movement_state.emit(movement_states["stand"])
	if Input.is_action_just_pressed("jump") and is_on_floor():
		pressed_jump.emit()

@rpc("any_peer")
func receive_damage():
	health -= 1
	if health <= 0:
		health = 10
		position = Vector3.ZERO
	health_changed.emit(health)
