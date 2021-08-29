extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_pressed("jump"):
		$JetPack/Particles.emitting = true
		$JetPack/Particles2.emitting = true
		$JetPack2/Particles3.emitting = true
		$JetPack2/Particles4.emitting = true
		get_parent().get_parent().vel.y += 0.3
		$HealthBar.visible = true
	else:
		$JetPack/Particles.emitting = false
		$JetPack/Particles2.emitting = false
		$JetPack2/Particles3.emitting = false
		$JetPack2/Particles4.emitting = false
		$HealthBar.visible = false
		#get_parent().vel.y = 0
