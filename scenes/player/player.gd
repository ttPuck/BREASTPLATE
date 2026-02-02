extends CharacterBody2D
## Player - Main player character with movement and networking
##
## This script handles:
## - Basic WASD movement
## - Authority-based input (only owner controls their player)
## - Network synchronization via MultiplayerSynchronizer
## - Camera management

@export var speed: float = 200.0

var health: float = 100.0

@onready var camera = $Camera2D
@onready var sprite = $Sprite2D

func _ready():
	# Set multiplayer authority based on player name (which is peer_id)
	var peer_id = name.to_int()
	set_multiplayer_authority(peer_id)

	# Only enable camera for local player
	if is_multiplayer_authority():
		camera.enabled = true
		print("Player %d: Camera enabled (local player)" % peer_id)
	else:
		camera.enabled = false
		print("Player %d: Camera disabled (remote player)" % peer_id)

	# Visual distinction for debugging (host is red, client is blue)
	if peer_id == 1:  # Host
		sprite.modulate = Color(1, 0.3, 0.3)  # Red tint
	else:  # Client
		sprite.modulate = Color(0.3, 0.3, 1)  # Blue tint

	# Add to player group for easy access
	add_to_group("player")

func _physics_process(delta: float):
	# Only the owner processes input
	if not is_multiplayer_authority():
		return

	# Get input direction
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# Apply movement
	velocity = input_direction * speed

	# Move character
	move_and_slide()

	# Rotate sprite to face movement direction (optional visual feedback)
	if input_direction.length() > 0:
		rotation = input_direction.angle()

## Take damage (server-authoritative)
@rpc("any_peer", "call_local", "reliable")
func take_damage(amount: float):
	if not multiplayer.is_server():
		return  # Server validates damage

	health -= amount
	health = max(0, health)

	print("Player %s took %d damage. Health: %d" % [name, amount, health])

	if health <= 0:
		die()

## Player death
func die():
	print("Player %s died!" % name)
	# TODO: Implement respawn logic in later phases
	queue_free()
