extends KinematicBody

var MAX_SPEED = 200
var thrust = 0
var move = false

var rolling = false
var prev_x = 0
var curr_x = 0

#var GRAVITY = -2
var MAX_SLOPE_ANGLE = 20
var ACCEL = 10
var DEACCEL = 0.1

var MOUSE_SENSITIVITY = 0.1
var MOUSE_MOVEMENT_THRESHOLD = 0.4

var Y_VEL_CONSTANT = 10
var Y_STABILIZE_CONSTANT = 0.92 * 0.02

var vel = Vector3()
var dir = Vector3()

var prev_vel = Vector3()

var camera
var rotation_helper


func _ready():
	camera = $RotationHelper/Camera
	rotation_helper = $RotationHelper

func _input(event):
	if event.is_action_pressed("EngineThrust"):
		move = true
	if event.is_action_released("EngineThrust"):
		move = false
		thrust *= 0.9
	
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		self.rotate_y(deg2rad(clamp(event.relative.x, -20, 20) * -0.15))
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		
		$MouseBody.rotate_z(-event.relative.x / 800)
		
		prev_x = curr_x
		curr_x = event.relative.x

		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -40, 40)
		rotation_helper.rotation_degrees = camera_rot

		$MouseBody/Stabilizers001.rotate_z(clamp(event.relative.y * MOUSE_SENSITIVITY * -0.03, -50, 50))
		$MouseBody/Stabilizers002.rotate_z(clamp(event.relative.y * MOUSE_SENSITIVITY * -0.03, -50, 50))
		
	if Input.is_action_pressed("boost"):
		MAX_SPEED = 1000
		ACCEL = 100
	else:
		MAX_SPEED = 200
		ACCEL = 10
		
func _physics_process(delta):
	dir = Vector3()
	var cam_xform = camera.get_global_transform()
	
	if move:
		if thrust < MAX_SPEED:
			thrust += 3
		else:
			thrust = MAX_SPEED
	if not move:
		thrust *= 0.97
		
	var thresh = 10
	$MouseBody.set_rotation(Vector3($MouseBody.get_rotation().x * 0.97, 1.571018, 0)) #$MouseBody.get_rotation().z)
	
	dir += cam_xform.basis.z
	
	dir.x *= -1
	dir.z *= -1
	dir.y *= -1

	var hvel = vel
	hvel.y = 0

	var target = dir
	target *= thrust
	

	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL
	
	hvel = hvel.linear_interpolate(target, accel * delta)	
	
	vel.x = hvel.x
	vel.z = hvel.z
	
	
#	if abs(dir.y) > MOUSE_MOVEMENT_THRESHOLD:
#		vel.y += dir.y * thrust / MAX_SPEED * Y_VEL_CONSTANT
#	else:
#		vel.y += dir.y * thrust / MAX_SPEED * Y_VEL_CONSTANT * delta * 1 * Y_STABILIZE_CONSTANT
	if move:
		vel.y = dir.y  * thrust
	else:
		if vel.y > -100:
			vel.y -= 1
	$YLabel.text = str(vel.y)
		
#	vel.y +=  delta * GRAVITY * 1
	
	if $RotationHelper/Camera.current:
		vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))	
	if (vel - prev_vel).length() > 10:
		pass
	
	$CoordsLabel.text = str(get_global_transform().origin)
	prev_vel = vel
	
