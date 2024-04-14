extends MarginContainer

@export var mouseInSide = false
var Card
var Attack :int = 0
var Armor : int = 0
var Health : int  = 0
var Speed : int = 0
var AttackType
var ImmuneToRange = false
var ImmuneToMelee = false

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
