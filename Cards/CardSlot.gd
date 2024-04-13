extends MarginContainer

func _ready():
	$Sprite2D.scale = size/$Sprite2D.texture.get_size()
