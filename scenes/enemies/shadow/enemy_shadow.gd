extends CharacterBody2D

@export var speed = 25
@export var accelleration = 7
@export var bullet_speed = 10
@export var bullet_delay = 1

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var shoot_timer: Timer = $ShootTimer
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var spawn_position: Vector2 = global_position

var bullet_prefab = preload("res://scenes/enemies/shadow/bullet/shadow_bullet.tscn")
var audio_ouch = preload("res://scenes/enemies/shadow/ShadowOuch.wav")
var audio_dies = preload("res://scenes/enemies/shadow/SchadowDies.wav")

var player: CharacterBody2D

var max_health := 50.0
var current_health := max_health

var is_pushed_back: bool = false

func _ready():
	shoot_timer.wait_time = bullet_delay
	nav_agent.max_speed = speed


func _physics_process(delta):
	if is_pushed_back:
		move_and_slide()
		return
	
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
	shoot()
	shoot_timer.start()

func _on_hunting_area_body_exited(body):
	if body.name == "PlayerCharacter":
		player = null
	shoot_timer.stop()

func shoot():
	if !player:
		return
	var dir = player.global_position - global_position
	dir = dir.normalized()
	var bullet: ShadowBullet = bullet_prefab.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_position = global_position + dir
	bullet.velocity = dir * bullet_speed


func hit(damage, hit_vector):
	is_pushed_back = true
	#print_debug("Hit for damage: ", damage)	
	current_health -= damage
	if current_health > 0:
		hit_flash(0.2)
		audio_player.stream = audio_ouch
	else:
		die_flash()
		audio_player.stream = audio_dies
	audio_player.play()
	velocity = hit_vector.normalized() * 100
	#print_debug("Health: ", current_health)
	await get_tree().create_timer(0.25).timeout
	is_pushed_back = false


func hit_flash(duration):
	var current_tween = get_tree().create_tween()
	current_tween.tween_property($Sprite2D, "modulate", Color(10, 10, 10), 0.1)
	current_tween.tween_interval(duration)
	current_tween.tween_property($Sprite2D, "modulate", Color(1, 1, 1), 0.1)
	

func die_flash():
	var current_tween = get_tree().create_tween()
	current_tween.connect("finished", on_die_flash_finished)
	current_tween.tween_property($Sprite2D, "modulate", Color(10, 10, 10), 0.1)
	current_tween.tween_interval(0.1)
	current_tween.tween_property($Sprite2D, "modulate", Color(1, 1, 1), 0.1)
	current_tween.tween_interval(0.1)
	current_tween.tween_property($Sprite2D, "modulate", Color(10, 10, 10), 0.1)
	current_tween.tween_interval(0.1)
	current_tween.tween_property($Sprite2D, "modulate", Color(1, 1, 1), 0.1)
	current_tween.tween_property($Sprite2D, "modulate:a", 0, 0.3)


func on_die_flash_finished():
	print_debug("free")
	queue_free()


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	if is_pushed_back:
		return
	velocity = safe_velocity
	move_and_slide()


func _on_navigation_timer_timeout():
	if player:
		nav_agent.target_position = player.global_position
	else:
		nav_agent.target_position = spawn_position


func _on_shoot_timer_timeout():
	shoot()


