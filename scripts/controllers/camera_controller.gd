extends Node3D

signal set_cam_rotation(_cam_rotation: float)

@onready var yaw_node = $CamYaw
@onready var pitch_node = $CamYaw/CamPitch
@onready var spring_arm = $CamYaw/CamPitch/SpringArm3D
@onready var camera = $CamYaw/CamPitch/SpringArm3D/Camera3D

enum {Third_Person, First_Person}
var view_mode = First_Person

var yaw: float = 0
var pitch: float = 0

var yaw_sensitivity: float = 0.07
var pitch_sensitivity: float = 0.07

var yaw_acceleration: float = 15
var pitch_acceleration: float = 15

var pitch_max: float = 75
var pitch_min: float = -55

func _input(event):
	if not is_multiplayer_authority(): return
	if event is InputEventMouseMotion:
		yaw += -event.relative.x * yaw_sensitivity
		pitch += event.relative.y * pitch_sensitivity
	if event.is_action_pressed("change_view"):
		if view_mode == First_Person:
			spring_arm.spring_length = 5
			view_mode = Third_Person
		elif view_mode == Third_Person:
			spring_arm.spring_length = 0
			view_mode = First_Person

func _physics_process(_delta):
	if not is_multiplayer_authority(): return
	pitch = clamp(pitch, pitch_min, pitch_max)
	
	#yaw_node.rotation_degrees.y = lerp(yaw_node.rotation_degrees.y, yaw, yaw_acceleration * delta)
	#pitch_node.rotation_degrees.x = lerp(pitch_node.rotation_degrees.x, pitch, pitch_acceleration * delta)
	
	yaw_node.rotation_degrees.y = yaw
	pitch_node.rotation_degrees.x = -pitch
	
	set_cam_rotation.emit(yaw_node.rotation.y)
	
