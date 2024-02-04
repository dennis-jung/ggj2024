extends Character
class_name Ally

signal has_been_hit

@export var player: PlayerCharacter
@export var jokes: Array[String]
@export var joke_interval: float = 5.0
@export var joke_interval_variance: float = 2.0

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _audio_player_ouch: AudioStreamPlayer = $AudioStreamPlayerOuch
@onready var _staff: AnimatedSprite2D = $Staff
@onready var _mount_points: MountPoints = $MountPoints
@onready var _navigation: Navigation = $Navigation
@onready var _joke_bubble: JokeBubble = $JokeBubble

var _speechbubble_scene = preload("res://scenes/speech_bubble/speech_bubble.tscn")

var _is_pushed_back: bool = false

func _ready():
	_mount_points.set_item_to_mount(_staff)
	_navigation.player = player
	_joke_bubble.joke_interval = joke_interval
	_joke_bubble.joke_interval_variance = joke_interval_variance
	_joke_bubble.jokes = jokes


func _physics_process(delta):
	if _is_pushed_back:
		move_and_slide()
		return
	
	_navigation.navigate_physics_process(delta)


func _on_navigation_navigation_velocity_computed(dir):
	select_animation(dir)
	_mount_points.set_mount_point(dir)


func select_animation(dir: Directions):
	if velocity.length() == 0:
		_sprite.stop()
	else:
		_sprite.play("walk_" + Directions.keys()[dir])
		_mount_points.set_mount_point(dir)


func hit(damage, hit_vector):
	_joke_bubble.shut_up()
	_is_pushed_back = true
	hit_flash()
	_audio_player_ouch.play()
	has_been_hit.emit()
	velocity = hit_vector.normalized() * 100
	await get_tree().create_timer(0.25).timeout
	_is_pushed_back = false	
	_joke_bubble.restart()


func hit_flash():
	var current_tween = get_tree().create_tween()
	current_tween.tween_property($AnimatedSprite2D, "modulate", Color(10, 10, 10), 0.1)
	current_tween.tween_interval(0.2)
	current_tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1), 0.1)

