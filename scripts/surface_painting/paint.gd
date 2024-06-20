extends CharacterBody3D

@export var color: Color = Color.BROWN
@export var speed = 10.0

@onready var draw_viewport: Viewport = $"/root/World/Environment/DrawViewport"

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func set_start_velocity():
	velocity = (global_transform.basis * Vector3.FORWARD).normalized() * speed

func _physics_process(delta):
	velocity.y -= gravity * delta
	
	move_and_slide()
	
	if get_slide_collision_count() > 0:
		for i in range(0, get_slide_collision_count()):
			var col = get_slide_collision(i)
			var uv = LevelUVPosition.get_uv_coords(col.get_position(), col.get_normal(), true)
			if uv:
				draw_viewport.paint(uv, color)
		queue_free()

