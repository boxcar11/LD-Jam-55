extends MarginContainer

class_name enemy

var currentHealth = 10
var maxHealth = 10
var maxMoveDistance = 100
var lane = -1
var speed : int = 1

func _ready():
	$VBoxContainer/ImageContainer/Image.scale *= $VBoxContainer/ImageContainer.custom_minimum_size/$VBoxContainer/ImageContainer/Image.texture.get_size()
	$VBoxContainer/Bar/TextureProgress.value = 100
	$VBoxContainer/Bar/Count/Background/Number.text = str(currentHealth)

func ChangeHealth(Number):
	currentHealth -= Number
	$VBoxContainer/Bar/TextureProgress.value = 100*currentHealth/maxHealth
	$VBoxContainer/Bar/Count/Background/Number.text = str(currentHealth)

func onDeath():
	# Has the chance to drop the player money or item
	pass