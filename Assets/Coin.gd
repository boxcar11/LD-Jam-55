extends Node2D

@onready var main = $/root/Main

var speed = 1.5
var move = false

var overCoin

func _process(_delta):
	if move:
		position.x -= speed
	pass

func _on_timer_timeout():
	move = true
	pass # Replace with function body.

func _on_button_mouse_entered():
	overCoin = true
	pass # Replace with function body.

func _on_button_mouse_exited():
	overCoin = false

func _on_button_button_up():
	if overCoin:
		main.bank += 1
		queue_free()
