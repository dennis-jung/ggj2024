extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func fade_in(duration: int):
	color_rect.color.a = 1.0
	color_rect.show()

func fade_out(duration: int):
	color_rect.color.a = 0.0
	color_rect.hide()

	
