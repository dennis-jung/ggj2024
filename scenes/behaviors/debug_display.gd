extends Control

@export var gradient: Gradient

func _draw():
	var parent = get_parent()
	var pos = parent.get_global_transform_with_canvas().origin - get_global_transform_with_canvas().origin	
	draw_arc(pos, 10.0, 0.0, 2 * PI, 32, Color.DEEP_PINK, 0.5, false)
	
	for sv: Vector2 in parent.get_steering_map():
		var color = gradient.sample(sv.length())
		draw_line(pos + sv.normalized() * 10, pos + sv * 10 + sv * 10, color, 1.0, false)
