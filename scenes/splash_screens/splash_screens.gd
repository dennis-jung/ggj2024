extends CanvasLayer
class_name SplashScreens

@export var display_time: float = 2.0
@export  var fade_time: float = 1.0
@export  var in_between_time: float = 1.0
@export var images: Array[TextureRect]
@onready var fader: ColorRect = $Fader
var index: int = -1
var current_image: TextureRect
var current_tween: Tween

func _ready():
	next()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		next()
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/levels/level_dj.tscn")
		

func next():
	index += 1
	print_debug("splash screen index: ", index)
	if index >= images.size():
		print_debug("exiting splash screens")
		get_tree().change_scene_to_file("res://scenes/levels/level_dj.tscn")
		return
	fader.color.a = 1.0
	current_image = images[index]
	current_image.show()
	current_tween = get_tree().create_tween()
	current_tween.connect("finished", on_tween_finished)
	current_tween.tween_property(fader, "color:a", 0.0, fade_time)
	current_tween.tween_interval(display_time)
	current_tween.tween_property(fader, "color:a", 1.0, fade_time)
	current_tween.tween_interval(in_between_time)
	

func on_tween_finished():
	print_debug("splash screen finished index: ", index)
	current_tween.kill()
	current_image.hide()
	next()
