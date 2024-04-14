extends TextureProgressBar

var maxHealth : float = 20
var health = maxHealth

func _ready():
	max_value = maxHealth

func ChangeHealth(Number):
	health -= Number
	value = 100*health/maxHealth
	#$VBoxContainer/Bar/Count/Background/Number.text = str(health)
