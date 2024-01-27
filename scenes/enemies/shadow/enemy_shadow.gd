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


func hit(damage):
	print_debug("Hit for damage: ", damage)	
	current_health -= damage
	hit_flash()
	print_debug("Health: ", current_health)


func hit_flash():
	var current_tween = get_tree().create_tween()
	current_tween.connect("finished", on_tween_finished)
	current_tween.tween_property($Sprite2D, "modulate", Color(10, 10, 10), 0.1)
	current_tween.tween_interval(0.2)
	current_tween.tween_property($Sprite2D, "modulate", Color(1, 1, 1), 0.1)


func on_tween_finished():
	if current_health <= 0:
		queue_free()
