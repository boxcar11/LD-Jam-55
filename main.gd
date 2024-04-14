extends Node

const EnemyList = preload("res://Cards/EnemyList.gd")
@onready var DeckSize = EnemyList.enemyList.size()

@export var waveMaxSize := 5
@export var minWaveTime := 5
@export var maxWaveTime := 15

@onready var Mob1 = $Camera2D/SubViewportContainer/SubViewport/PlaySpace/EnemyArea/VBoxContainer/mobLane1
@onready var Mob2 = $Camera2D/SubViewportContainer/SubViewport/PlaySpace/EnemyArea/VBoxContainer/mobLane2
@onready var Mob3 = $Camera2D/SubViewportContainer/SubViewport/PlaySpace/EnemyArea/VBoxContainer/mobLane3
@onready var Mob4 = $Camera2D/SubViewportContainer/SubViewport/PlaySpace/EnemyArea/VBoxContainer/MobLane4

var enemyLocations = []
var mobCount= []
var mobCountWidth = 4

@onready var EnemyArea = $Camera2D/SubViewportContainer/SubViewport/PlaySpace/EnemyArea
@onready var timer = $WaveTimer

const Enemy = preload("res://Assets/Cards/Enemies/enemy.tscn")

const PLAYER_START_POS := Vector2(150, 532)
const CAM_START_POS := Vector2(576, 324)
const MAX_SPEED : int = 25
@export var StartSpeed := 2.0
var speed : float
var screen_size : Vector2i
var enemyStartCount = 0

@export var subView := SubViewport

func _ready():
	screen_size = get_window().size
	new_game()
	setEnemyLocations()

func new_game():
	$Player.position = PLAYER_START_POS
	$Player.velocity = Vector2(0, 0)
	$Camera2D.position = CAM_START_POS
	$Ground.position = Vector2i(0,0)
	EnemyWaveGenerator()
	
func setEnemyLocations():
	enemyLocations.append(Mob1)
	enemyLocations.append(Mob2)
	enemyLocations.append(Mob3)
	enemyLocations.append(Mob4)

	for i in mobCountWidth:
		mobCount.append([])

func _process(_delta):
	speed = StartSpeed

	# Move player and camera
	$Player.position.x += speed
	$Camera2D.position.x += speed

	# Update ground position
	if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
		$Ground.position.x += screen_size.x



	for j in mobCount.size():
		for k in mobCount[j].size():
			#print("J:" + str(j)+ " K:" + str(k))
			if mobCount[j][k] != null:
				var enemyChild = mobCount[j][k]
				if enemyChild.Health <= 0:
					mobCount[j].remove_at(0)
					enemyChild.queue_free()
					break
				enemyChild.maxMoveDistance = 100 + k*50
				if enemyChild.position.x < enemyChild.maxMoveDistance:
					pass
				else:
					enemyChild.position.x -= speed

func _input(event):
	if event.is_action_pressed("leftclick"): # Pick up card	
		_StartEnemy()

func _StartEnemy():
	print("Create Enemy")
	var newEnemy = Enemy.instantiate()
	var i = randi() % enemyLocations.size()
	var enemySelected = randi() % DeckSize
	newEnemy.enemyName = EnemyList.enemyList[enemySelected]
	EnemyArea.add_child(newEnemy)
	mobCount[i].append(newEnemy)
	newEnemy.lane = i
	newEnemy.position = enemyLocations[i].position + Vector2(1500,0)
	enemyStartCount -= 1
	if enemyStartCount == 0:
		EnemyWaveGenerator()
	

func EnemyWaveGenerator():
	var waveSize = randi() % waveMaxSize
	var waveStart = randf_range(minWaveTime, maxWaveTime)
	timer.start(waveStart)
	enemyStartCount = waveSize

func _on_EnemyStart_timeout():
	_StartEnemy()

func _on_WaveCoolDown_timeout():
	pass
