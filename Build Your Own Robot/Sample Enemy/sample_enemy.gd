extends KinematicBody

const id = "sample enemy"

var health = 20
var damage = 5
var vel = Vector3()
var lock = false

var isInProximity

var target
var sight = 40
var dirTimer = 0

func _ready():
	$AnimationPlayer.playback_speed=3
	isInProximity = false
	target = get_parent().get_node("Robot")
	vel = Vector3(1, 0, 0)
	

func _physics_process(delta):
	if !target.is_dead:
		if lock:
			target()
		else:
			roam()
		
		var collision = move_and_collide(vel.normalized())
		dirTimer -= delta
		
		if get_global_transform().origin.y < -20:
			kill()
		
		if isInProximity:
			attack()

func roam():
	if dirTimer <= 0:
			var angle = rand_range(-PI/2, PI/2)
			vel = vel.rotated(Vector3(0, 1, 0), angle).normalized() * 0.1
			vel.y = -10
			dirTimer = rand_range(5, 15)
			if get_global_transform().origin.distance_to(target.get_global_transform().origin) < sight:
				lock = true

func target():
	look_at(target.get_global_transform().origin, Vector3(0, 1, 0))
	rotation.x = 0
	vel = get_global_transform().origin.direction_to(target.get_global_transform().origin).normalized()
	vel.y = -0.3

func bullet_hit(damage):
	health -= damage
	if health <= 0:
		kill()

func kill():
	$AnimationPlayer.play("Death")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Death":
		if !$AnimationPlayer.is_playing():
			$AnimationPlayer.stop()
		queue_free()


func attack():
	if $AttackTimer.is_stopped() and health > 0:
		get_parent().get_node("Robot").health -= damage
		$AnimationPlayer.playback_speed=5
		$AnimationPlayer.play("Attack")
		$AnimationPlayer.playback_speed=3
		$AttackTimer.start()
	


func _on_Area_body_entered(body):
	if body.id == "player":
		isInProximity = true


func _on_Area_body_exited(body):
	if body.id == "player":
		isInProximity = false
