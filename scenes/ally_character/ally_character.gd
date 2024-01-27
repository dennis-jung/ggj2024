extends CharacterBody2D

@export var player: PlayerCharacter
@export var speed: float = 300
@export var accelleration: float = 7
@export var speech_delay: float = 5.0

@onready var nav_agent: NavigationAgent2D = $Navigation/NavigationAgent2D
@onready var speech_timer = $SpeechTimer

@onready var speechbubble_scene = preload("res://scenes/speech_bubble/textbox.tscn")


const lines: Array[String] = [
	"Let's get them, like the king got the crabs!",
	"This guy looks like his parents were 1st cousins, just like with the king's line.",
	"Third insult here!"
]

func _ready():
	speech_timer.start(speech_delay)

func _physics_process(delta):
	var direction = Vector2.ZERO
	direction = nav_agent.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * speed, accelleration * delta)
	move_and_slide()


func _on_timer_timeout():
	nav_agent.target_position = player.global_position

func _on_speech_timer_timeout():
		# give speech
	var textbox = speechbubble_scene.instantiate()
	self.add_child(textbox)
	textbox.global_position = global_position
	textbox.display_text(lines[0])
	# reset timer
	speech_timer.start(speech_delay)

