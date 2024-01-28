extends CharacterBody2D

@export var player: PlayerCharacter
@export var speed: float = 60
@export var accelleration: float = 7
@export var speech_delay: float = 7.0

@onready var nav_agent: NavigationAgent2D = $Navigation/NavigationAgent2D
@onready var speech_timer = $SpeechTimer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var speechbubble_scene = preload("res://scenes/speech_bubble/textbox.tscn")


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
	speech_timer.start(speech_delay)
	nav_agent.max_speed = speed


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


func _on_timer_timeout():
	nav_agent.target_position = player.global_position

func _on_speech_timer_timeout():
		# give speech
	var textbox = speechbubble_scene.instantiate()
	self.add_child(textbox)
	textbox.global_position = global_position
	#randomize()
	var random_line = lines[randi_range(0,lines.size()-1)]
	textbox.display_text(random_line)
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
