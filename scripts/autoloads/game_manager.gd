extends Node
## Game Manager - Manages game state and safehouse logic
##
## This singleton manages:
## - Game state (menu, lobby, playing, paused)
## - Safehouse designation and benefits
## - Session tracking
## - World state

enum GameState { MENU, LOBBY, PLAYING, PAUSED }

var current_state: GameState = GameState.MENU
var safehouse_position: Vector2 = Vector2.ZERO
var safehouse_radius: float = 200.0

func _ready():
	pass

# TODO: Implement game state transitions
# TODO: Implement safehouse designation
# TODO: Implement safehouse benefit checks
