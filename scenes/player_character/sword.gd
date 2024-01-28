extends Sprite2D
class_name Sword

@onready var anim_sword: AnimationPlayer = $"../AnimationPlayerSword"

func _on_area_2d_body_entered(body):
	# should only trigger during attack animation
	if !anim_sword.is_playing():
		return
	# print_debug("_on_area_2d_body_entered: ", body)
	if body.has_method("hit"):
		body.hit(10, body.global_position - global_position)



