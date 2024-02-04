extends CharacterBody2D
class_name Character


enum Directions { up, down, left, right }


func get_direction_from_velocity(velo: Vector2) -> Directions:
	if velo.x < 0:
		return Directions.left
	elif velo.x > 0:
		return Directions.right
	elif velo.y > 0:
		return Directions.down
	return Directions.up
