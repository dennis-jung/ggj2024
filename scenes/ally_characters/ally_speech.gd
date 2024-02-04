extends Node2D

@export var lines: Array[String] = []
@export var interval: float = 7.0
@export var audio: AudioStream = null

@onready var _speech_timer = $Timer
@onready var _audio_player = $AudioPlayer

var _speechbubble_scene = preload("res://scenes/speech_bubble/speech_bubble.tscn")


func _ready():
	_speech_timer.start(interval)


func _on_speech_timer_timeout():
	# remove existing speech bubble(s)
	remove_speech_bubbles()
	# create speech bubble
	var bubble = _speechbubble_scene.instantiate()
	self.add_child(bubble)
	bubble.global_position = global_position
	# show random line
	var random_line = lines[randi_range(0, lines.size()-1)]
	bubble.display_text(random_line)
	# play audio
	_play_audio()


func _play_audio():
	if audio:
		_audio_player.stream = audio
		_audio_player.play()


func remove_speech_bubbles():
	for child in get_children():
		if child is SpeechBubble:
			child.queue_free()
	_audio_player.stop()
