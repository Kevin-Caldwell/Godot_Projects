extends Spatial

var bullet = preload("res://Robot/Turret/Bullet/Bullet_Mesh.tscn")

var timeLeft
const RELOAD_TIME = 0.5
const damage = 10
var ammo
const INITIAL_AMMO = 30

func _ready():
	$"Reload Timer".wait_time = RELOAD_TIME
	ammo = INITIAL_AMMO

func _physics_process(delta):
	timeLeft = $"Reload Timer".time_left

func _input(event):
	if event.is_action_pressed("fire") && ammo > 0:
		if $"Reload Timer".is_stopped():
			var new_bullet = bullet.instance()
			var scene_root = get_tree().root.get_children()[0]
			scene_root.add_child(new_bullet)
			new_bullet.global_transform = $AimPoint.global_transform
			ammo -= 1
			
			$"Reload Timer".start()