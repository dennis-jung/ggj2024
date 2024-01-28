extends CharacterBody2D

@export var speed = 100
@export var accelleration = 7

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var player: CharacterBody2D

var max_health := 100.0
var current_health := max_health

func _physics_process(delta):
	if nav_agent.is_navigation_finished():
		return
		
	var direction = Vector2.ZERO
	direction = nav_agent.get_next_path_position() - global_position
	direction = direction.normalized()
	var new_velocity = velocity.lerp(direction * speed, accelleration * delta)
	if nav_agent.avoidance_enabled:
		nav_agent.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)

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


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()


func _on_navigation_timer_timeout():
	if player:
		nav_agent.target_position = player.global_position
	else:
		nav_agent.target_position = Vector2.ZERO
