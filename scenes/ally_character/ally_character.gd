extends CharacterBody2D

@export var player: PlayerCharacter
@export var speed: float = 300
@export var accelleration: float = 7

@onready var nav_agent: NavigationAgent2D = $Navigation/NavigationAgent2D


func _physics_process(delta):
	var  direction = Vector2.ZERO
	direction = nav_agent.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * speed, accelleration * delta)
	move_and_slide()


func _on_timer_timeout():
	nav_agent.target_position = player.global_position
