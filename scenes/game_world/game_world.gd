extends Node2D
## GameWorld - Main game level container
##
## This scene serves as the container for:
## - Player characters
## - AI enemies
## - Map/terrain
## - Items and containers

func _ready():
	print("GameWorld ready")

	# Add background color for visibility
	RenderingServer.set_default_clear_color(Color(0.2, 0.2, 0.25))  # Dark blue-gray
