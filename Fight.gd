extends Node

@onready var enemyArea =$".."/Camera2D/SubViewportContainer/SubViewport/PlaySpace/EnemyArea
@onready var roundTimer = $".."/RoundTimer

var fighters = []

func _ready():
	pass

func _BattleRound():
	_Get_Fighters()
	roundTimer.start(1)

func _Get_Fighters():
	# Add all enemies in view
	for i in range(enemyArea.get_child_count()-1):
		var curEnemy = enemyArea.get_child(i+1)
		if curEnemy.position.x < 400:
			curEnemy.canFight = true
	# Add all creatures in spots
	# if Slot0.Card != null:
	# 	Slot0.canFight = true
	# if Slot1.Card != null:
	# 	Slot0.canFight = true		
	# if Slot2.Card != null:
	# 	Slot0.canFight = true
	# if Slot3.Card != null:
	# 	Slot0.canFight = true
	# if Slot4.Card != null:
	# 	Slot0.canFight = true

func _on_round_timer_timeout():
	_BattleRound()

