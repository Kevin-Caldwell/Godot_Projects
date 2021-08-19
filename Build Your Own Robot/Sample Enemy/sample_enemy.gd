extends KinematicBody

const id = "sample enemy"

var health = 20
var damage = 5

func _ready():
	$AnimationPlayer.playback_speed=5

func _physics_process(delta):
	if !get_parent().robot.is_dead:
		var r = get_parent().get_node("Robot").get_global_transform().origin
		look_at(r, Vector3(0, 1, 0))
		rotation.x = 0
		#rotation.y = -PI/2
		var vel = get_global_transform().origin.direction_to(r)
		#print(get_global_transform().origin.distance_to(r))
		if get_global_transform().origin.distance_to(r) < 6:
			attack()
		
		var collision = move_and_collide(vel.normalized()/25)
	

func bullet_hit(damage):
	health -= damage
	if health <= 0:
		kill()

func kill():
	$AnimationPlayer.play("Death")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Death":
		queue_free()


func attack():
	if $AttackTimer.is_stopped():
		get_parent().get_node("Robot").health -= damage
		$AnimationPlayer.play("Attack")
		$AttackTimer.start()
