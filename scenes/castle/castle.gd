extends Node2D

@onready var _animated_sprite = $AnimatedSprite2D

var is_game_over := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
	if is_game_over:
		_animated_sprite.play("open")
	else:
		_animated_sprite.stop()


func _on_area_2d_body_entered(body):
	# check if it's the player
	if body.get_name() == "PlayerCharacter":
		print("Open!")
		is_game_over = true



func _on_area_2d_body_exited(body):
	if body.get_name() == "PlayerCharacter":
		print("Open!")
		is_game_over = false
