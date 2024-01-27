extends StateMachineState

func enter():
	print_debug("state entered: ", self)
	await get_tree().create_timer(2.0).timeout
	exit()


func exit():
	fsm.change_to("State2")


func _unhandled_key_input(event):
	if event.pressed:
		print_debug("From State1: ", event.keycode)
	
