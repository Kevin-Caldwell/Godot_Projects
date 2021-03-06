extends Spatial

const id = "bullet"

var BULLET_SPEED = 150
var BULLET_DAMAGE = 15
var KILL_TIMER = 1
var timer = 0
var forward_dir

var hit_something = false

func _ready():
	$Area.connect("body_entered", self, "collided")


func _physics_process(delta):
	forward_dir = global_transform.basis.x.normalized()
	global_translate(forward_dir * BULLET_SPEED * delta)

	timer += delta
	if timer >= KILL_TIMER:
		queue_free()


func collided(body):
	if hit_something == false:
		if body.has_method("bullet_hit"):
			body.bullet_hit(BULLET_DAMAGE)
	if body.id == "player":
		pass
	else:
		hit_something = true
		queue_free()
