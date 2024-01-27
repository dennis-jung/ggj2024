extends CharacterBody2D

var player: CharacterBody2D

const SPEED = 300.0

func _physics_process(delta):
	move_and_slide()

func _on_hunting_area_body_entered(body):
	if body.name == "PlayerCharacter":
		player = body
	
func _on_hunting_area_body_exited(body):
	if body.name == "PlayerCharacter":
		player = null
