extends Node

const JUMP_VELOCITY = 4.5

@export var player: CharacterBody3D
@export var mesh_root: Node3D
@export var rotation_speed: float = 8

var direction: Vector3
var velocity: Vector3
var acceleration: float
var speed: float
var cam_rotation: float = 0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	
	velocity.x = speed * direction.x
	velocity.z = speed * direction.z
	
	if not player.is_on_floor():
		player.velocity.y -= gravity * delta
	
	#player.velocity = player.velocity.lerp(velocity, acceleration * delta)
	player.velocity.x = lerpf(player.velocity.x, velocity.x, acceleration * delta)
	player.velocity.z = lerpf(player.velocity.z, velocity.z, acceleration * delta)
	player.move_and_slide()
	
	
	var target_rotation = atan2(direction.x, direction.z) - player.rotation.y
	mesh_root.rotation.y = lerp_angle(mesh_root.rotation.y, target_rotation, rotation_speed * delta)
	

func _jump():
	player.velocity.y = JUMP_VELOCITY
	

func _on_set_movement_state(_movement_state: MovementState):
	speed = _movement_state.movement_speed
	acceleration = _movement_state.acceleration

func _on_set_movement_direction(_movement_direction: Vector3):
	direction = _movement_direction.rotated(Vector3.UP, cam_rotation)

func _on_set_cam_rotation(_cam_rotation: float):
	cam_rotation = _cam_rotation
