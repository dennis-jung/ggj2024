extends CharacterBody2D

var player: CharacterBody2D

var max_health := 100.0
var current_health := max_health

const SPEED = 100.0

func _physics_process(delta):
	move_and_slide()

func _on_hunting_area_body_entered(body):
	if body.name == "PlayerCharacter":
		player = body
	
func _on_hunting_area_body_exited(body):
	if body.name == "PlayerCharacter":
		player = null
