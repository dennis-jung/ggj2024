extends Node2D
class_name JokeBubble

var jokes: Array[String] = []
var joke_interval: float = 5.0
var joke_interval_variance: float = 2.0

@onready var _joke_timer: Timer = $JokeTimer
@onready var _audio_player_bells: AudioStreamPlayer = $AudioStreamPlayerBells
@onready var _bubble: SpeechBubble = $SpeechBubble

func _ready():
	_joke_timer.start(_get_next_joke_interval())


func _get_next_joke_interval():
	return joke_interval + randf_range(0.0, joke_interval_variance)


func _get_next_joke() -> String:
	if !jokes:
		return ""
	return jokes[randi_range(0,jokes.size()-1)]


func show_joke():
	if !jokes:
		return
	
	_audio_player_bells.play()
	_bubble.display_text(_get_next_joke())
	_bubble.show()
	_joke_timer.start(_get_next_joke_interval())


func hide_joke():
	_bubble.hide()


func shut_up():
	_joke_timer.stop()
	hide_joke()


func restart():
	_joke_timer.start(_get_next_joke_interval())


func _on_joke_timer_timeout():
	show_joke()
