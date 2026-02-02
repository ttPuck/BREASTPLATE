extends Node
## Constants - Game-wide constant values
##
## This file contains all constant values used throughout the game
## for easy tuning and balancing.

# Player dimensions (in pixels)
const PLAYER_HEIGHT = 32.0
const STANDING_HEIGHT = PLAYER_HEIGHT
const CROUCH_HEIGHT = PLAYER_HEIGHT / 3.0  # 1/3 height
const PRONE_HEIGHT = PLAYER_HEIGHT / 11.0  # 1/11 height

# Movement speeds (pixels per second)
const BASE_WALK_SPEED = 100.0
const CROUCH_SPEED_MULT = 0.5
const PRONE_SPEED_MULT = 0.3
const READY_JOG_MULT = 1.5
const SPRINT_MULT = 2.0

# Combat constants
const T_BOX_INSTANT_KILL_DAMAGE = 999.9
const HEADSHOT_MULTIPLIER = 5.0
const TORSO_MULTIPLIER = 1.0
const LIMB_MULTIPLIER = 0.5

# Vision constants
const DEFAULT_VISION_CONE_ANGLE = 90.0  # degrees
const DEFAULT_VISION_RANGE = 500.0  # pixels
const DEFAULT_RAYCAST_COUNT = 32

# Inventory constants
const INVENTORY_GRID_WIDTH = 10
const INVENTORY_GRID_HEIGHT = 6
const MAX_CARRY_WEIGHT_KG = 50.0

# Clambering constants
const CLAMBERING_HEIGHT_THRESHOLD = PLAYER_HEIGHT * 0.5  # Can clamber up to half player height
const CLIMBING_MIN_HEIGHT = PLAYER_HEIGHT * 1.5  # Minimum height for climbing (windows, ladders)
const CLIMBING_MAX_HEIGHT = PLAYER_HEIGHT * 3.0  # Maximum climbable height

# Network constants
const DEFAULT_SERVER_PORT = 7777
const MAX_PLAYERS = 2

# Safehouse constants
const SAFEHOUSE_RADIUS = 200.0  # pixels

# AI constants
const INFECTED_DETECTION_RANGE = 300.0  # pixels
const INFECTED_CHASE_SPEED = 80.0  # pixels per second
const INFECTED_HEALTH = 50.0

# Ballistics constants
const BULLET_MAX_DISTANCE = 1000.0  # pixels
const DAMAGE_FALLOFF_START_DISTANCE = 50.0  # Start damage falloff after this distance
const DAMAGE_FALLOFF_MAX_DISTANCE = 250.0  # Max distance for damage calculation

# Accuracy constants
const ACCURACY_RNG_DISTANCE_THRESHOLD = 20.0  # meters - within this use RNG for T-box hits
const BASE_ACCURACY = 0.95  # 95% accuracy at optimal conditions
