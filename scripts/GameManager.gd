extends Node

signal game_start(player: CharacterBody3D)

const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

var Players: Dictionary = {}
var world
#var own_username: String
#
func _ready():
	multiplayer.connected_to_server.connect(connected_to_server)
	

func _unhandled_input(_event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

#TODO: Add Address & Port to host & join
func hosting_world(username: String):
	world = load("res://scenes/dev/world.tscn").instantiate()
	var start_screen = get_tree().root.get_child(get_tree().root.get_child_count() - 1)
	get_tree().root.add_child(world)
	start_screen.queue_free()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(world.add_player)
	multiplayer.peer_disconnected.connect(world.remove_player)
	
	world.add_player(multiplayer.get_unique_id())
	world.SendPlayerInformation(username, multiplayer.get_unique_id())

func joining_world(username: String):
	world = load("res://scenes/world.tscn").instantiate()
	var start_screen = get_tree().root.get_child(get_tree().root.get_child_count() - 1)
	get_tree().root.add_child(world)
	start_screen.queue_free()
	
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer
	world.SendPlayerInformation(username, multiplayer.get_unique_id())

#func add_player(peer_id):
	#var player = Player.instantiate()
	#player.name = str(peer_id)
	#world.add_child(player)
	#if player.is_multiplayer_authority():
		#game_start.emit(player)
		#player.health_changed.connect(update_health_bar)
#
#func remove_player(peer_id):
	#var player = get_node_or_null(str(peer_id))
	#if player:
		#player.queue_free()

#func update_health_bar(health_value):
	#health_bar.value = health_value
#
#func _on_multiplayer_spawner_spawned(node):
	#if node.is_multiplayer_authority():
		#node.health_changed.connect(update_health_bar)

func connected_to_server():
	var id = multiplayer.get_unique_id()
	world.SendPlayerInformation.rpc_id(1, GameManager.Players[id].username, id)
#
#@rpc("any_peer")
#func SendPlayerInformation(username, id):
	#if !GameManager.Players.has(id):
		#GameManager.Players[id] = {
			#"username" : username,
			#"id" : id,
			#"holding" : null
		#}
	#
	#if multiplayer.is_server():
		#for i in GameManager.Players:
			#SendPlayerInformation.rpc(GameManager.Players[i].username, i)
