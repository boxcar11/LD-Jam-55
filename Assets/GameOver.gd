extends Control

func _on_main_menu_button_button_up():
	pass

func _on_retry_button_button_up():
	get_tree().change_scene_to_file("res://main.tscn")
