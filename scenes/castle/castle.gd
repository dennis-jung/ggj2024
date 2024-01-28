extends Node2D

@onready var _animated_sprite = $AnimatedSprite2D

@onready var speechbubble_scene = preload("res://scenes/speech_bubble/textbox.tscn")

@export var _enemy_container: Node2D

signal game_ended

const feedback := "Noone is laughing yet. You need to get rid of all Buzzkills!"

var is_game_over := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func check_enemies_dead() -> bool:
	if _enemy_container.get_child_count() > 0:
		return false
	return true

func _on_area_2d_body_entered(body):
	# check if it's the player
	if body.get_name() == "PlayerCharacter":
		if check_enemies_dead():			
			print("Open!")
			_animated_sprite.play("open")
			is_game_over = true
			
			game_ended.emit()
		else:
			var textbox = speechbubble_scene.instantiate()
			self.add_child(textbox)
			textbox.global_position = global_position
			textbox.display_text(feedback)


func _on_area_2d_body_exited(body):
	if body.get_name() == "PlayerCharacter":
		print("Open!")
		is_game_over = false
