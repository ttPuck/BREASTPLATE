extends Node
## Event Bus - Global signal hub for decoupled communication
##
## This singleton provides global signals for communication between systems
## without tight coupling. Systems can emit and listen to signals without
## direct references to each other.

# Player events
signal player_health_changed(player_id: int, new_health: float)
signal player_died(player_id: int)
signal player_respawned(player_id: int, position: Vector2)

# Combat events
signal weapon_fired(player_id: int, weapon_id: String)
signal hit_registered(attacker_id: int, target_id: int, damage: float)

# Inventory events
signal item_picked_up(player_id: int, item_id: String)
signal item_dropped(player_id: int, item_id: String)
signal inventory_changed(player_id: int)

# Game state events
signal game_started()
signal game_paused()
signal game_resumed()
signal safehouse_designated(position: Vector2)

func _ready():
	pass
