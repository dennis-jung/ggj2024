extends Node2D

var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if player:
		DebugDraw2D.line(global_position, player.global_position)
	
func _on_hunting_area_body_entered(body):
	if body.name == "PlayerCharacter":
		player = body
	
func _on_hunting_area_body_exited(body):
	if body.name == "PlayerCharacter":
		player = null
