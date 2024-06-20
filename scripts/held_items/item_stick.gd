extends HeldItem

func _unhandled_input(_event):
	if not owner.is_multiplayer_authority(): return
	if active_item:
		if Input.is_action_just_pressed("primary") and can_do_primary:
			can_do_primary = false
			play_hit_effects.rpc()
			if raycast.is_colliding():
				var hit_player = raycast.get_collider()
				hit_player.receive_damage.rpc_id(hit_player.get_multiplayer_authority())


@rpc("any_peer", "call_local")
func play_hit_effects():
	action_started.emit()
	anim_player.play("primary")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "primary":
		can_do_primary = true
	
	action_finished.emit()
