extends MarginContainer

@onready var enemyArea = $"../../../.."/EnemyArea

@export var mouseInSide = false
var Card
var Attack : int = 0
var Armor : int = 0
var Health : int  = 0
var Speed : int = 0
var AttackType
var Immune = 0
var canFight : bool = false

var maxHealth : float = 20

var timer := Timer.new()
var fighting = false


signal mouseIn

func _ready():
	$TextureProgressBar.max_value = maxHealth
	add_child(timer)
	timer.timeout.connect(_on_fight_timeout)

func _process(_delta):
	if enemyArea.get_child_count() > 1:
		if enemyArea.get_child(1).position.x < 400:
			if canFight && !fighting:
				fighting = true
				Fight()

func Fight():
	if enemyArea.get_child(1) != null:
		enemyArea.get_child(1).ChangeHealth(Attack)
		timer.start(Speed)

func ChangeHealth(Number):
	print("Creature Damage: " + str(Number))
	Health -= Number
	UpdateHealthBar()
	
func UpdateHealthBar():
	$TextureProgressBar.value = Health
	$TextureProgressBar.max_value = maxHealth

func _on_mouse_exited():
	mouseInSide = false

	if Card != null:
		Card.mouse_exited()
	# print("Mouse Left")
	mouseIn.emit(false)

func _on_mouse_entered():
	mouseInSide = true

	if Card != null:
		Card.mouse_entered()
	# print("Mouse Entered")
	mouseIn.emit(true)
	
func _on_fight_timeout():
	Fight()
