extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_castle_game_ended():
	get_tree().change_scene_to_file("res://scenes/end_screen/end_screen.tscn")
