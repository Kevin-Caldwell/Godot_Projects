extends Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		self.rotate_y(deg2rad(clamp(event.relative.x, -20, 20) * -0.15))
		self.rotate_x(deg2rad(clamp(event.relative.y, -20, 20) * -0.15))

func _physics_process(delta):
	if Input.is_action_pressed("forward"):
		get_transform().origin.x+=10
	if Input.is_action_pressed("back"):
		get_transform().origin.x=-10
	if Input.is_action_pressed("left"):
		get_transform().origin.z+=10
	if Input.is_action_pressed("right"):
		get_transform().origin.z-=10


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
