extends Node2D
class_name SteeringBehavior

var direction_map = []
var collision_map = []

func _ready():
	direction_map.append(Vector2(0, -1).normalized())
	direction_map.append(Vector2(1, -1).normalized())
	direction_map.append(Vector2(1, 0).normalized())
	direction_map.append(Vector2(1, 1).normalized())
	direction_map.append(Vector2(0, 1).normalized())
	direction_map.append(Vector2(-1, 1).normalized())
	direction_map.append(Vector2(-1, 0).normalized())
	direction_map.append(Vector2(-1, -1).normalized())


func _physics_process(delta):
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters2D.create(Vector2(0, 0), Vector2(50, 100))
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	if result:
		print_debug("Hit at point: ", result.position)

func get_steering_map():
	pass	
