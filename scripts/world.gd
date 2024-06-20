extends Node

signal player_spawned(player: CharacterBody3D)
signal player_removed(player: CharacterBody3D)

const Player = preload("res://scenes/characters/player_third_person.tscn")

func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child(player)
	if player.is_multiplayer_authority():
		player_spawned.emit(player)

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player_removed.emit(player)
		player.queue_free()

func _on_multiplayer_spawner_spawned(player):
	if player.is_multiplayer_authority():
		player_spawned.emit(player)

@rpc("any_peer")
func SendPlayerInformation(username, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"username" : username,
			"id" : id,
			"holding" : null
		}
	
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[i].username, i)
