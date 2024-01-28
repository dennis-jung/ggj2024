extends MarginContainer

@onready var label = $MarginContainer/Label
@onready var timer = $ShutupTimer

var talk_time := 5.0

const MAX_WIDTH = 256 # Pixels

var text := ""

func display_text(text_to_display: String):
	print("Displaying text")
	text = text_to_display
	label.text = text_to_display
	
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized # wait for x resize
		await resized # await y resize
		custom_minimum_size.y = size.y
		
	#global_position.x -= size.x / 2
	global_position.y -= size.y + 20
	
	timer.start(talk_time)

func _on_shutup_timer_timeout():
	text = ""
	label.text = ""
	queue_free()
