extends Node2D
class_name  Navigation

signal navigation_velocity_computed(dir: Character.Directions)

@export var character: Character
@export var speed: float = 60
@export var accelleration: float = 7

var player: PlayerCharacter = null

@onready var _nav_agent: NavigationAgent2D = $NavigationAgent2D


func _ready():
	_nav_agent.max_speed = speed


func navigate_physics_process(delta):
	if !character or _nav_agent.is_navigation_finished():
		return
		
	var direction = Vector2.ZERO
	direction = _nav_agent.get_next_path_position() - character.global_position
	direction = direction.normalized()
	var new_velocity = character.velocity.lerp(direction * speed, accelleration * delta)
	if _nav_agent.avoidance_enabled:
		_nav_agent.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	if !character:
		return
		
	character.velocity = safe_velocity
	var dir = character.get_direction_from_velocity(character.velocity)
	navigation_velocity_computed.emit(dir)
	character.move_and_slide()


func _on_timer_timeout():
	if !player:
		return
		
	_nav_agent.target_position = player.global_position
