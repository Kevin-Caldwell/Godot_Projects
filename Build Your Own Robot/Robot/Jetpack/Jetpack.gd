extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time_left = 50


# Called when the node enters the scene tree for the first time.
func _ready():
	$JetPack/Particles.emitting = true
	$JetPack/Particles2.emitting = true
	$JetPack2/Particles3.emitting = true
	$JetPack2/Particles4.emitting = true

func _process(delta):
	if Input.is_action_pressed("jump") and time_left >= 0:
		$JetPack/Particles.emitting = true
		$JetPack/Particles2.emitting = true
		$JetPack2/Particles3.emitting = true
		$JetPack2/Particles4.emitting = true
		get_parent().get_parent().vel.y += 1#0.3
		time_left-= delta
		$HealthBar.visible = true
	else:
		$JetPack/Particles.emitting = false
		$JetPack/Particles2.emitting = false
		$JetPack2/Particles3.emitting = false
		$JetPack2/Particles4.emitting = false
		$HealthBar.visible = false
