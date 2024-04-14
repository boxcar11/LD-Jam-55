extends Node

const PLAYER_START_POS := Vector2(150, 532)
const CAM_START_POS := Vector2(576, 324)

var speed : float
@export var StartSpeed := 5.0
const MAX_SPEED : int = 25
var screen_size : Vector2i

func _ready():
	screen_size = get_window().size
	new_game()

func new_game():
	$Player.position = PLAYER_START_POS
	$Player.velocity = Vector2(0, 0)
	$Camera2D.position = CAM_START_POS
	$Ground.position = Vector2i(0,0)
	

func _process(_delta):
	speed = StartSpeed

	# Move player and camera
	$Player.position.x += speed
	$Camera2D.position.x += speed

	# Update ground position
	if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
		$Ground.position.x += screen_size.x
	
	
