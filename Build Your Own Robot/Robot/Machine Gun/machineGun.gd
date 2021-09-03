extends Spatial

var bullet = preload("res://Robot/Turret/Bullet/Bullet_Mesh.tscn")

var timeLeft
var RELOAD_TIME = 0.75
const damage = 1
var ammo
const MAX_AMMO = -1
const chambers = 8
var curr = 0
var firing = false
var scene_root
var bullets = []

func _ready():
	#$"Reload Timer".wait_time = RELOAD_TIME
	ammo = MAX_AMMO
	fire_particles()
	RELOAD_TIME = $"Reload Timer".wait_time
	scene_root = get_tree().root.get_children()[0]


func _process(delta):
	timeLeft = $"Reload Timer".time_left
	if firing:
		fire_particles()
		if !$AnimationPlayer.is_playing():
			$AnimationPlayer.play("fire")
		if ammo != 0:
			if $"Reload Timer".is_stopped():
				fire(curr)
				curr += 1
				if curr == chambers:
					curr = 0
				$"Reload Timer".start()
			else:
				pass
		else:
			pass
	else:
		stop_particles()
	
	

func _input(event):
	if event.is_action_pressed("fire"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			firing = true
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action_released("fire"):
		firing  = false

func fire_particles():
	$Cube/Particles/Particles1.emitting = true
	$Cube/Particles/Particles2.emitting = true
	$Cube/Particles/Particles3.emitting = true
	$Cube/Particles/Particles4.emitting = true
	$Cube/Particles/Particles5.emitting = true
	$Cube/Particles/Particles6.emitting = true
	$Cube/Particles/Particles7.emitting = true
	$Cube/Particles/Particles8.emitting = true

func stop_particles():
	$Cube/Particles/Particles1.emitting = false
	$Cube/Particles/Particles2.emitting = false
	$Cube/Particles/Particles3.emitting = false
	$Cube/Particles/Particles4.emitting = false
	$Cube/Particles/Particles5.emitting = false
	$Cube/Particles/Particles6.emitting = false
	$Cube/Particles/Particles7.emitting = false
	$Cube/Particles/Particles8.emitting = false

func fire_particle(i):
	get_node("Cube/Particles/Particles" + str(i + 1)).emitting = true

func fire(i):
		var new_bullet = bullet.instance()
		scene_root.add_child(new_bullet)
		new_bullet.BULLET_DAMAGE = 1
		new_bullet.global_transform = get_node("Cube/Aimpoints/Aimpoint" + str(i + 1)).global_transform
		#new_bullet.global_rotate(Vector3(), rand_range(-20,20))
		new_bullet.KILL_TIMER = 0.5
		ammo -= 1
		#print(ammo)
