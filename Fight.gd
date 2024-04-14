extends Node

@export var player : TextureProgressBar
@onready var Slot0 = $".."/Camera2D/SubViewportContainer/SubViewport/PlaySpace/Control/HBoxContainer/VBoxContainer2/Slot1
@onready var Slot1 = $".."/Camera2D/SubViewportContainer/SubViewport/PlaySpace/Control/HBoxContainer/VBoxContainer2/Slot2
@onready var Slot2 = $".."/Camera2D/SubViewportContainer/SubViewport/PlaySpace/Control/HBoxContainer/VBoxContainer2/Slot3
@onready var Slot3 = $".."/Camera2D/SubViewportContainer/SubViewport/PlaySpace/Control/HBoxContainer/VBoxContainer/Slot4
@onready var Slot4 = $".."/Camera2D/SubViewportContainer/SubViewport/PlaySpace/Control/HBoxContainer/VBoxContainer/Slot5

@onready var enemyArea =$".."/Camera2D/SubViewportContainer/SubViewport/PlaySpace/EnemyArea
@onready var roundTimer = $".."/RoundTimer

var fighters = []

func _ready():
	pass

func _BattleRound():
	_Get_Fighters()
	_Get_Order()
	roundTimer.start(15)

func _Get_Fighters():
	var value
	# Add all enemies in view
	for i in range(enemyArea.get_child_count()-1):
		var curEnemy = enemyArea.get_child(i+1)
		if curEnemy.position.x < 400:
			value = [curEnemy.speed, curEnemy]
			fighters.append(value)
	# Add all creatures in spots
	if Slot0.Card != null:
		value = [Slot0.Speed, Slot0]
		fighters.append(value)
	if Slot1.Card != null:
		value = [Slot1.Speed, Slot1]
		fighters.append(value)		
	if Slot2.Card != null:
		value = [Slot2.Speed, Slot2]
		fighters.append(value)
	if Slot3.Card != null:
		value = [Slot3.Speed, Slot3]
		fighters.append(value)
	if Slot4.Card != null:
		print(Slot4.Speed)
		value = [Slot4.Speed, Slot4]
		fighters.append(value)

func _Get_Order():
	print(fighters)
	fighters.sort_custom(sort_descending)
	print(fighters)

func sort_descending(a, b):
	if a[0] > b[0]:
		return true
	return false

func _on_Round_timeout():
	_BattleRound()
