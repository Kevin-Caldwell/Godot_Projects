extends Spatial

export (PackedScene) var Mob

var MOB_COUNT = 7
var mobs = []
var robot


func _ready():
	randomize()
	robot = $Robot
	

func _process(delta):
	$GUI/Health.text = str($Robot.health)
	$GUI/AmmoProgress.set_value(float($Robot.turret.ammo) / float($Robot.turret.INITIAL_AMMO) * 100)
	$GUI/AmmoLeft.set_text(str($Robot.turret.ammo))
	$GUI/ReloadBar.set_value($Robot.turret.get_node("Reload Timer").get_time_left() * 100)
	#print($GUI/ReloadBar2.value)
	if $Robot.turret.ammo == 0:
		$GUI/OutOfAmmo.visible = true
	else:
		$GUI/OutOfAmmo.visible = false


	if mobs.size() < MOB_COUNT:
		var mob = Mob.instance()
		add_child(mob)

		mob.translate(Vector3(rand_range(-25, 25), 1, rand_range(-25, 25)))
		mobs.push_front(mob)

