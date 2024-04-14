extends MarginContainer

class_name enemy

var enemyName = 'Archer'
@onready var CardInfo = CardDatabase.DATA[CardDatabase.get(enemyName)]
@onready var CardImg = str("res://assets/Cards/",CardInfo[0],"/",enemyName,".png")

@onready var Slot0 = $"../.."/Control/HBoxContainer/VBoxContainer2/Slot1
@onready var Slot1 = $"../.."/Control/HBoxContainer/VBoxContainer2/Slot2
@onready var Slot2 = $"../.."/Control/HBoxContainer/VBoxContainer2/Slot3
@onready var Slot3 = $"../.."/Control/HBoxContainer/VBoxContainer/Slot4
@onready var Slot4 = $"../.."/Control/HBoxContainer/VBoxContainer/Slot5

var maxHealth = 10
var maxMoveDistance = 100
var lane = -1
var speed : int = 1
var canFight : bool = false

var Attack : int = 0
var Armor : int = 0
var Health : int  = 0
var Speed : int = 0
var AttackType
var Immune = 0

var oppenent = []
var timer := Timer.new()
var fighting = false

func _ready():
	$VBoxContainer/ImageContainer/Image.scale *= $VBoxContainer/ImageContainer.custom_minimum_size/$VBoxContainer/ImageContainer/Image.texture.get_size()
	$VBoxContainer/Bar/TextureProgress.value = 100
	
	add_child(timer)
	timer.timeout.connect(_on_fight_timeout)

	$VBoxContainer/ImageContainer/Image.texture = load(CardImg)

	Attack = CardInfo[1]
	Armor = CardInfo[2]
	Health = CardInfo[3]
	maxHealth = CardInfo[3]
	Speed = CardInfo[4]
	AttackType = CardInfo[7]
	canFight = true
	if CardInfo[5] == 6:
		Immune = 1
	else:
		Immune = 0
	if CardInfo[5] == 7:
		Immune = 2
	else:
		Immune = 0

func ChangeHealth(Number):
	print("EnemyDamage: " + str(Number))
	Health -= Number
	#print("Took: " + str(Number) + " Damage")
	$VBoxContainer/Bar/TextureProgress.value = Health
	$VBoxContainer/Bar/TextureProgress.max_value = maxHealth
	$VBoxContainer/Bar/Count/Background/Number.text = str(Health)

func FindOppenent():
	if Slot0.Card != null && !CheckForImmune(Slot0.Immune):
		var value = [Slot0.Health, Slot0]
		oppenent.append(value)
	if Slot1.Card != null && !CheckForImmune(Slot1.Immune):
		var value = [Slot1.Health, Slot1]
		oppenent.append(value)
	if Slot2.Card != null && !CheckForImmune(Slot2.Immune):
		var value = [Slot2.Health, Slot2]
		oppenent.append(value )
	if Slot3.Card != null && !CheckForImmune(Slot3.Immune):
		var value = [Slot3.Health, Slot3]
		oppenent.append(value)
	if Slot4.Card != null && !CheckForImmune(Slot4.Immune):
		var value = [Slot4.Health, Slot4]
		oppenent.append(value)

	oppenent.sort_custom(sort_descending)

func sort_descending(a, b):
	if a[0] < b[0]:
		return true
	return false

func CheckForImmune(immuneType):
	if AttackType == "Melee" && immuneType == 2:
		return true
	elif AttackType == "Ranged" && immuneType == 1:
		return true
	else:
		return false

func _process(_delta):
	if position.x < 400:
		if canFight && !fighting:
			fighting = true
			Fight()

func Fight():

		FindOppenent()
		if oppenent.size() > 0:
			oppenent[0][1].ChangeHealth(Attack)
			timer.start(Speed)

func _on_fight_timeout():
	Fight()
