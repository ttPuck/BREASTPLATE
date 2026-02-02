extends Control
## Main Menu - Entry point for the game
##
## Provides UI for hosting or joining multiplayer games

const GAME_WORLD_SCENE = preload("res://scenes/game_world/game_world.tscn")

@onready var host_button = $VBoxContainer/HostButton
@onready var join_button = $VBoxContainer/JoinButton
@onready var ip_input = $VBoxContainer/IPInput
@onready var status_label = $VBoxContainer/StatusLabel

func _ready():
	# Set default IP
	ip_input.text = "127.0.0.1"

	# Connect to NetworkManager signals
	NetworkManager.player_connected.connect(_on_player_connected)
	NetworkManager.player_disconnected.connect(_on_player_disconnected)
	NetworkManager.connection_failed.connect(_on_connection_failed)
	NetworkManager.server_created.connect(_on_server_created)
	NetworkManager.joined_server.connect(_on_joined_server)

func _on_host_button_pressed():
	status_label.text = "Status: Creating server..."
	host_button.disabled = true
	join_button.disabled = true

	NetworkManager.create_server()

func _on_join_button_pressed():
	var ip = ip_input.text
	if ip.is_empty():
		status_label.text = "Status: Please enter an IP address"
		return

	status_label.text = "Status: Connecting to " + ip + "..."
	host_button.disabled = true
	join_button.disabled = true

	NetworkManager.join_server(ip)

func _on_server_created():
	status_label.text = "Status: Server created! Waiting for players..."
	# Transition to game world
	call_deferred("_load_game_world")

func _on_joined_server():
	status_label.text = "Status: Connected to server!"
	# Transition to game world
	call_deferred("_load_game_world")

func _on_player_connected(peer_id: int):
	status_label.text = "Status: Player %d connected! Starting game..." % peer_id

func _on_player_disconnected(peer_id: int):
	status_label.text = "Status: Player %d disconnected" % peer_id

func _on_connection_failed(reason: String):
	status_label.text = "Status: " + reason
	host_button.disabled = false
	join_button.disabled = false

func _load_game_world():
	# Switch to game world scene
	get_tree().change_scene_to_packed(GAME_WORLD_SCENE)
