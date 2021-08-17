extends Spatial

var bullet = preload("res://Bullet_Mesh.tscn")

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("fire"):
		var new_bullet = bullet.instance()
		var scene_root = get_tree().root.get_children()[0]
		scene_root.add_child(new_bullet)
		new_bullet.global_transform = $AimPoint.global_transform
