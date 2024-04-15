extends Control



func _on_Exit_button_button_up():
	get_tree().quit()

func _on_deck_button_button_up():
	pass # Replace with function body.

func _on_play_button_button_up():
	get_tree().change_scene_to_file("res://main.tscn")
