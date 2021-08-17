extends KinematicBody

const GRAVITY = -24.8
const MAX_SPEED = 20
const JUMP_SPEED = 18
const ACCEL = 4.5
const MAX_SPRINT_SPEED = 30
const SPRINT_ACCEL = 18
var is_sprinting = false

var dir = Vector3()
var vel = Vector3()

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

var camera
var rotation_helper

var MOUSE_SENSITIVITY = 0.1


# Called when the node enters the scene tree for the first time.
func _ready():
	rotation_helper = $Rotation_Helper
	camera = $Rotation_Helper/Camera
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Mechanical_Legs/AnimationPlayer.playback_speed = 4
	

func process_input(delta):
	dir = Vector3()
	var cam_xform = camera.get_global_transform()

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
	if $Mechanical_Legs/AnimationPlayer.is_playing():
		if vel.x == 0:
			$Mechanical_Legs/AnimationPlayer.stop()
	if !$Mechanical_Legs/AnimationPlayer.is_playing():
		if vel.x > 0:
			$Mechanical_Legs/AnimationPlayer.play("Walk")
		if vel.x < 0:
			$Mechanical_Legs/AnimationPlayer.play_backwards("Walk")
			
	

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)
