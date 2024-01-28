extends Control


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/levels/level_dj.tscn")
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
