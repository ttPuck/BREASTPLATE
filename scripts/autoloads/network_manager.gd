extends Node
## Network Manager - Handles P2P LAN multiplayer connection and player spawning
##
## This singleton manages:
## - Creating/joining servers
## - Player spawn synchronization
## - RPC communication
## - Peer connection/disconnection events

signal player_connected(peer_id: int)
signal player_disconnected(peer_id: int)
signal connection_failed(reason: String)
signal server_created()
signal joined_server()

const PLAYER_SCENE = preload("res://scenes/player/player.tscn")

var peer: ENetMultiplayerPeer
var is_host: bool = false
var players: Dictionary = {}  # peer_id -> player_node

func _ready():
	# Connect to multiplayer signals
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

## Create a server that other players can join
func create_server(port: int = 7777) -> void:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)  # Max 2 players

	if error != OK:
		connection_failed.emit("Failed to create server on port %d" % port)
		push_error("Failed to create server: Error code %d" % error)
		return

	multiplayer.multiplayer_peer = peer
	is_host = true

	print("Server created on port %d" % port)
	server_created.emit()

	# Host spawns their own player immediately
	_spawn_player(multiplayer.get_unique_id())

## Join an existing server
func join_server(address: String, port: int = 7777) -> void:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, port)

	if error != OK:
		connection_failed.emit("Failed to connect to %s:%d" % [address, port])
		push_error("Failed to connect to server: Error code %d" % error)
		return

	multiplayer.multiplayer_peer = peer
	is_host = false

	print("Attempting to connect to %s:%d" % [address, port])

## Called when a peer connects (server-side)
func _on_peer_connected(peer_id: int) -> void:
	print("Peer %d connected" % peer_id)
	player_connected.emit(peer_id)

	# Only server spawns players
	if multiplayer.is_server():
		# Spawn player for newly connected peer
		_spawn_player(peer_id)

## Called when a peer disconnects
func _on_peer_disconnected(peer_id: int) -> void:
	print("Peer %d disconnected" % peer_id)
	player_disconnected.emit(peer_id)

	# Remove player from game
	if players.has(peer_id):
		players[peer_id].queue_free()
		players.erase(peer_id)

## Called when client successfully connects to server
func _on_connected_to_server() -> void:
	print("Successfully connected to server")
	joined_server.emit()

## Called when connection to server fails
func _on_connection_failed() -> void:
	print("Connection to server failed")
	connection_failed.emit("Unable to connect to server")

## Called when server disconnects
func _on_server_disconnected() -> void:
	print("Server disconnected")
	connection_failed.emit("Server disconnected")

	# Clean up
	multiplayer.multiplayer_peer = null
	for player in players.values():
		player.queue_free()
	players.clear()

## Spawn a player for the given peer ID
func _spawn_player(peer_id: int) -> void:
	# Only server should spawn
	if not multiplayer.is_server():
		return

	# Don't spawn duplicate players
	if players.has(peer_id):
		return

	# Call RPC to spawn on all clients
	spawn_player.rpc(peer_id)

## RPC: Spawn player on all clients (called by server)
@rpc("authority", "call_local", "reliable")
func spawn_player(peer_id: int) -> void:
	var player = PLAYER_SCENE.instantiate()
	player.name = str(peer_id)

	# Get game world (will be created in next step)
	var game_world = get_tree().root.get_node_or_null("GameWorld")
	if game_world:
		game_world.add_child(player)

		# Set spawn position (spread players apart)
		var spawn_offset = Vector2(100, 0) if peer_id % 2 == 0 else Vector2(-100, 0)
		player.global_position = Vector2(960, 540) + spawn_offset  # Center of 1920x1080

		# Store reference
		players[peer_id] = player

		print("Spawned player for peer %d" % peer_id)
	else:
		push_error("GameWorld scene not found! Cannot spawn player.")

## Get the local player node
func get_local_player() -> Node:
	var local_id = multiplayer.get_unique_id()
	return players.get(local_id)

## Disconnect from multiplayer session
func disconnect_session() -> void:
	if peer:
		peer.close()
		multiplayer.multiplayer_peer = null

	is_host = false

	# Clean up players
	for player in players.values():
		player.queue_free()
	players.clear()

	print("Disconnected from multiplayer session")
