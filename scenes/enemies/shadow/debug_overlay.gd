extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var screen_centre = get_viewport().size/2
	DebugDraw2D.line(global_position, Vector2(1,2))
	


func _on_hunting_area_area_entered(area):
	pass # Replace with function body.
