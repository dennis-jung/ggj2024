extends Node2D
class_name SteeringBehavior

@export var character_body: CharacterBody2D

const full_collision_value = 5
const neighbor_collision_value = 2

var direction_map: Array[Vector2] = []
var collision_map: Array[float] = []
var danger_map: Array[float] = []
var interest_map: Array[float] = []
var steering_map: Array[Vector2] = []

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
	create_collision_map()
	create_danger_map()
	create_interest_map()
	combine_maps()


func create_collision_map():
	var coll_map: Array[float] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]

	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node!
	var test = character_body.collision_mask
	for i in direction_map.size():
		var query = PhysicsRayQueryParameters2D.create(
			character_body.global_position, character_body.global_position + direction_map[i] * 10, 
			character_body.collision_mask, 
			[character_body])
		var result = space_state.intersect_ray(query)
		if result:
			# print_debug("Hit result: dir={0} rid={1}".format([dir, result.rid]))
			# set hit direction to full value
			coll_map[i] = full_collision_value
			coll_map[get_neighbor_dir_plus(i)] = neighbor_collision_value
			coll_map[get_neighbor_dir_minus(i)] = neighbor_collision_value
			# print_debug("Collision map: ", collision_map)
			
	collision_map = coll_map


func create_danger_map():
	danger_map = collision_map


func create_interest_map():
	var intr_map: Array[float] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
	interest_map = intr_map


func get_neighbor_dir_plus(index: int):
	var neighbor_dir = index + 1
	if neighbor_dir >= direction_map.size():
		neighbor_dir = 0
	return neighbor_dir


func get_neighbor_dir_minus(index: int):
	var neighbor_dir = index - 1
	if neighbor_dir < 0:
		neighbor_dir = direction_map.size() - 1
	return neighbor_dir


func combine_maps():
	var str_map: Array[Vector2]
	str_map.resize(8)
	for i in direction_map.size():
		var avoid = danger_map[i] + collision_map[i]
		var goto = interest_map[i]
		var factor = clampf(goto - avoid, -10.0, 10.0)
		str_map[i] = direction_map[i] * (factor)
	steering_map = str_map

func get_steering_map():
	return steering_map


