extends Spatial

var bullet = preload("res://Robot/Turret/Bullet/Bullet_Mesh.tscn")

var timeLeft
const RELOAD_TIME = 0.75
const damage = 20
var ammo
const MAX_AMMO = 15

func _ready():
	$"Reload Timer".wait_time = RELOAD_TIME
	ammo = MAX_AMMO
	$Particles.emitting = true

func _process(delta):
	timeLeft = $"Reload Timer".time_left

func _input(event):
	if event.is_action_pressed("fire"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			if ammo != 0:
				if $"Reload Timer".is_stopped():
					$Particles.emitting = true
					fire()
					$"Reload Timer".start()
				else:
					pass
			else:
				pass
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func fire():
		var new_bullet = bullet.instance()
		var scene_root = get_tree().root.get_children()[0]
		scene_root.add_child(new_bullet)
		new_bullet.global_transform = $AimPoint.global_transform
		ammo -= 1
