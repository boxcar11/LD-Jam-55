extends MarginContainer

func _ready():
	$Sprite.scale = size/$Sprite2D.texture.get_size()
