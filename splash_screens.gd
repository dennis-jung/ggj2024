extends CanvasLayer
class_name SplashScreens

@export var display_time: float = 2.0
@export  var fade_time: float = 1.0
@export  var in_between_time: float = 1.0
@export var images: Array[TextureRect]
var index: int = -1
var current_image: TextureRect
var current_tween: Tween

func _ready():
	next()


func next():
	index += 1
	print_debug("splash screen index: ", index)
	if index >= images.size():
		print_debug("exiting splash screens")
		return
	current_image = images[index]
	current_image.modulate.a8 = 0
	current_image.show()
	current_tween = get_tree().create_tween()
	current_tween.connect("finished", on_tween_finished)
	current_tween.tween_property(self, "modulate:a8", 255, fade_time)
	current_tween.tween_interval(display_time)
	current_tween.tween_property(self, "modulate:a8", 0, fade_time)
	current_tween.tween_interval(in_between_time)
	

func on_tween_finished():
	print_debug("splash screen finished index: ", index)
	current_tween.kill()
	current_image.hide()
	next()
