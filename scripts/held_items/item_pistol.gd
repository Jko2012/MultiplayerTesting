extends HeldItem

@export var projectile: PackedScene

#@onready var ammo_capacity = 10
#@onready var ammo_left = 10
#@onready var ammo_held = 20

@onready var world = $"/root/World/Environment"
@onready var projectile_spawnpoint = $Pistol/ProjectileSpawn

func _unhandled_input(_event):
	if not owner.is_multiplayer_authority(): return
	if active_item:
		if Input.is_action_just_pressed("primary"):# and can_do_primary
			can_do_primary = false
			play_shoot_effects.rpc()
			var p = projectile.instantiate() as CharacterBody3D
			world.add_child(p)
			p.speed += owner.velocity.length()
			p.global_position = projectile_spawnpoint.global_position
			p.global_rotation = global_rotation
			#p.rotate_x(deg_to_rad(rng.randf_range(-rotation_variance, rotation_variance)))
			#p.rotate_y(deg_to_rad(rng.randf_range(-rotation_variance, rotation_variance)))
			p.set_start_velocity()
			if raycast.is_colliding():
				var hit_player = raycast.get_collider()
				hit_player.receive_damage.rpc_id(hit_player.get_multiplayer_authority())


@rpc("any_peer", "call_local")
func play_shoot_effects():
	action_started.emit()
	anim_player.play("primary")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "primary":
		can_do_primary = true
	
	action_finished.emit()
