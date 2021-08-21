extends KinematicBody

const id = "player"

var turret_scene = preload("res://Robot/Turret/Turret.tscn")
var mech_legs_scene = preload("res://Robot/Mechanical Legs/Mechanical_Legs.tscn")

const MAX_HEALTH = 100
var health = 100

const MAX_SPEED = 7
const JUMP_SPEED = 9
const MAX_SPRINT_SPEED = 10
const ACCEL = 4.5
const DEACCEL= 8
const SPRINT_ACCEL = 9
const GRAVITY = -12.4

var is_sprinting = false
var is_dead = false
var curr_cam = -1

var dir = Vector3()
var vel = Vector3()

const MAX_SLOPE_ANGLE = 40

var camera
var rotation_helper
var turret
var movement
var movement_player

var cameras = []

var MOUSE_SENSITIVITY = 0.1


# Called when the node enters the scene tree for the first time.
func _ready():
	rotation_helper = $Rotation_Helper
	camera = $Rotation_Helper/RobotView
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	turret = turret_scene.instance()
	add_child(turret)
	turret.rotate_y(-PI/2)
	turret.translate(Vector3(0, 1.624, 0))
	
	movement = mech_legs_scene.instance()
	add_child(movement)
	movement.rotate_y(PI)
	movement.translate(Vector3(0, -0.958, 0))
	
	movement_player = movement.get_node("AnimationPlayer")
	movement_player.playback_speed = 6
	
	$AnimationPlayer.seek(0)
	turret.get_node("AnimationPlayer").seek(0)
	movement.get_node("AnimationPlayer").seek(0)
	
	$RegenTimer.start()
	
	cameras.append($Rotation_Helper/BehindView)
	cameras.append($RobotView)
	cameras.append($Rotation_Helper/MoveableView)
	
	cam_select()

func process_input(delta):
	dir = Vector3()
	var cam_xform = rotation_helper.get_global_transform()

	var input_movement_vector = Vector2()

	if Input.is_action_pressed("forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("right"):
		input_movement_vector.x += 1
	# ----------------------------------
	# Sprinting
	if Input.is_action_pressed("sprint"):
		is_sprinting = true
	else:
		is_sprinting = false
	# ----------------------------------


	# ----------------------------------
	input_movement_vector = input_movement_vector.normalized()

	# Basis vectors are already normalized.
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
	# ----------------------------------

	# ----------------------------------
	# Jumping
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			vel.y = JUMP_SPEED
	# ----------------------------------

	# ----------------------------------
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# ----------------------------------
		
	# ----------------------------------
	# Changing weapons.
	
func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()

	vel.y += delta * GRAVITY

	var hvel = vel
	hvel.y = 0

	var target = dir
	if is_sprinting:
		target *= MAX_SPRINT_SPEED
	else:
		target *= MAX_SPEED

	var accel
	if dir.dot(hvel) > 0:
		if is_sprinting:
			accel = SPRINT_ACCEL
		else:
			accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

	if movement_player.is_playing():
		if vel.x == 0:
			movement_player.stop()
	if !movement_player.is_playing():
		if vel.x > 0:
			movement_player.play("Walk")
		if vel.x < 0:
			movement_player.play_backwards("Walk")

func _input(event):
	if event is InputEventMouseMotion and !is_dead:
		
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
			self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
			
			var camera_rot = rotation_helper.rotation_degrees
			camera_rot.x = clamp(camera_rot.x, -70, 90)
			rotation_helper.rotation_degrees = camera_rot
		#else:
			#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	if !is_dead:
		process_input(delta)
		process_movement(delta)
	if get_global_transform().origin.y < -20 and !is_dead:
		health-=1

func _process(delta):
	if health <= 0 and !is_dead:
		die()
	
	if Input.is_action_just_pressed("cam_switch"):
		cam_select()
	
	$GUI/Health.text = str(health)
	if health < 0:
		$GUI/Health.text = str(0) 
	$GUI/AmmoProgress.set_value(float(turret.ammo) / float(turret.MAX_AMMO) * 100)
	$GUI/AmmoLeft.set_text(str(turret.ammo))
	$GUI/ReloadBar.set_value(((turret.RELOAD_TIME - turret.get_node("Reload Timer").get_time_left())/turret.RELOAD_TIME) * 100)
	$GUI/HealthBar.set_value(health)
	
	if turret.ammo == 0:
		$GUI/OutOfAmmo.visible = true
	else:
		$GUI/OutOfAmmo.visible = false

func die():
	$AnimationPlayer.play("Death")
	turret.get_node("AnimationPlayer").play("Death")
	movement.get_node("AnimationPlayer").play("Death")
	is_dead = true


func _on_RegenTimer_timeout():
	if !is_dead:
		health+=5
		if health > MAX_HEALTH:
			health = MAX_HEALTH

func cam_select():
	curr_cam += 1
	if curr_cam == 3:
		curr_cam = 0
	camera = cameras[curr_cam]
	camera.current = true
