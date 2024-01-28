extends Node2D
class_name ShadowBullet

var velocity: Vector2

func _ready():
	$Sprite2D.modulate = Color.AQUA

func _process(delta):
	position += velocity * delta


func _on_area_2d_body_entered(body):
	if body.name == "PlayerCharacter":
		body.hit(1)
	queue_free()


func set_velocity(velo: Vector2):
	velocity = velo
