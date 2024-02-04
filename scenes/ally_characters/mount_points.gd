extends Node2D
class_name MountPoints

var _mount_points = {}
var _item_to_mount: Node2D = null

func _ready():
	_mount_points[Ally.Directions.up] = $MountPointUp
	_mount_points[Ally.Directions.down] = $MountPointDown
	_mount_points[Ally.Directions.left] = $MountPointLeft
	_mount_points[Ally.Directions.right] = $MountPointRight

func set_item_to_mount(item: Node2D):
	_item_to_mount = item

func set_mount_point(dir: Ally.Directions):
	if !_item_to_mount:
		return
	_item_to_mount.global_position = _mount_points[dir].global_position
	_item_to_mount.z_index = _mount_points[dir].z_index
