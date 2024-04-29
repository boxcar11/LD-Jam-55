extends enemy

class_name miniBoss


# Called when the node enters the scene tree for the first time.
func setName() -> void:
	pass # Replace with function body.

func _ready():
	$VBoxContainer/ImageContainer/Image.scale *= $VBoxContainer/ImageContainer.custom_minimum_size/$VBoxContainer/ImageContainer/Image.texture.get_size()
	$VBoxContainer/Bar/TextureProgress.value = 100
	$VBoxContainer/Bar/Count/Background/Number.text = str(currentHealth)

func ChangeHealth(Number):
	currentHealth -= Number
	$VBoxContainer/Bar/TextureProgress.value = 100*currentHealth/maxHealth
	$VBoxContainer/Bar/Count/Background/Number.text = str(currentHealth)

func _onDeath():
	pass
	# Randomly gives player one new card