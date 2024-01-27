extends CharacterBody2D
class_name PlayerCharacter

@export var speed: int = 100
@onready var anim_walk: AnimationPlayer = $AnimationPlayerWalk
@onready var anim_sword: AnimationPlayer = $AnimationPlayerSword
@onready var sword: Sprite2D = $Sword

var weapon_mount_points = {}
var current_weapon: Sprite2D = null
var current_direction: String = "down"


func _ready():
	weapon_mount_points["up"] = $WeaponMountPointUp
	weapon_mount_points["down"] = $WeaponMountPointDown
	weapon_mount_points["left"] = $WeaponMountPointLeft
	weapon_mount_points["right"] = $WeaponMountPointRight
	# quick hack for initial character direction
	current_direction = "down"
	$Sprite2D.frame = 0
	sword.rotation = 0
	set_weapon_mount_point(current_direction)


func _unhandled_input(event):
	if event.is_action_pressed("player_attack"):
		anim_sword.play("attack_" + current_direction)


func get_input():
	var input_direction = Input.get_vector(
		"player_left",
		"player_right",
		"player_up",
		"player_down")
	velocity = input_direction * speed


func select_animation():
	if velocity.length() == 0:
		anim_walk.stop()
	else:
		var dir = "up"
		if velocity.x < 0:
			dir = "left"
		elif velocity.x > 0:
			dir = "right"
		elif velocity.y > 0:
			dir = "down"
		current_direction = dir
		anim_walk.play("walk_" + dir)
		set_weapon_mount_point(dir)


func set_weapon_mount_point(dir: String):
		sword.position = weapon_mount_points[dir].position
		sword.z_index = weapon_mount_points[dir].z_index
		sword.frame = 2


func _physics_process(_delta):
	get_input()
	select_animation()
	move_and_slide()
