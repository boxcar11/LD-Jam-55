extends MarginContainer

@export var mouseInSide = false
var Card

signal mouseIn

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

# func _on_focus_mouse_entered():
# 	print("Focus")
