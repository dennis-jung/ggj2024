extends CharacterBody2D

signal has_been_hit

@export var player: PlayerCharacter
@export var speed: float = 60
@export var accelleration: float = 7
@export var speech_delay: float = 7.0

@onready var nav_agent: NavigationAgent2D = $Navigation/NavigationAgent2D
@onready var speech_timer = $SpeechTimer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_plaer_bells: AudioStreamPlayer = $AudioStreamPlayerBells
@onready var staff: AnimatedSprite2D = $Staff

@onready var speechbubble_scene = preload("res://scenes/speech_bubble/textbox.tscn")

var staff_mount_points = {}

var is_pushed_back: bool = false

const lines: Array[String] = [
	"<Pun missing>",
	"!Punchline",
	"main.c crashed",
	"A <NullPointerException> comes into a bar",
	"HeapOverflow detected",
	"{Placeholder}",
	"Uh-oh"
]

func _ready():
	staff_mount_points["up"] = $StaffMountPointUp
	staff_mount_points["down"] = $StaffMountPointDown
	staff_mount_points["left"] = $StaffMountPointLeft
	staff_mount_points["right"] = $StaffMountPointRight
	speech_timer.start(speech_delay)
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


func _on_timer_timeout():
	nav_agent.target_position = player.global_position

func _on_speech_timer_timeout():
	audio_plaer_bells.play()
	# give speech
	var textbox = speechbubble_scene.instantiate()
	self.add_child(textbox)
	textbox.global_position = global_position
	#randomize()
	var random_line = lines[randi_range(0,lines.size()-1)]
	textbox.display_text(random_line)
	has_been_hit.connect(textbox._on_shutup_timer_timeout)
	# reset timer
	speech_timer.start(speech_delay)



func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	select_animation()
	move_and_slide()


func select_animation():
	if velocity.length() == 0:
		sprite.stop()
	else:
		var dir = "up"
		if velocity.x < 0:
			dir = "left"
		elif velocity.x > 0:
			dir = "right"
		elif velocity.y > 0:
			dir = "down"
		sprite.play("walk_" + dir)
		set_weapon_mount_point(dir)

func set_weapon_mount_point(dir: String):
		staff.position = staff_mount_points[dir].position
		staff.z_index = staff_mount_points[dir].z_index


func hit(damage, hit_vector):
	is_pushed_back = true
	hit_flash()
	audio_player.play()
	has_been_hit.emit()
	velocity = hit_vector.normalized() * 100
	await get_tree().create_timer(0.25).timeout
	is_pushed_back = false


func hit_flash():
	var current_tween = get_tree().create_tween()
	current_tween.tween_property($AnimatedSprite2D, "modulate", Color(10, 10, 10), 0.1)
	current_tween.tween_interval(0.2)
	current_tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1), 0.1)
