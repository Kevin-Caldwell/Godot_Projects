extends Spatial

export (PackedScene) var Mob

var MOB_COUNT = 7
var mobs = []
var robot


func _ready():
	randomize()
	robot = $Robot
	robot.turret.fire()
	

func _process(delta):
	$GUI/Health.text = str($Robot.health)
	$GUI/AmmoProgress.set_value(float(robot.turret.ammo) / float($Robot.turret.INITIAL_AMMO) * 100)
	$GUI/AmmoLeft.set_text(str(robot.turret.ammo))
	$GUI/ReloadBar.set_value(((robot.turret.RELOAD_TIME - robot.turret.get_node("Reload Timer").get_time_left())/robot.turret.RELOAD_TIME) * 100)
	$GUI/HealthBar.set_value(robot.health)
	#print($GUI/ReloadBar.value)
	if $Robot.turret.ammo == 0:
		$GUI/OutOfAmmo.visible = true
	else:
		$GUI/OutOfAmmo.visible = false


	if mobs.size() < MOB_COUNT:
		var mob = Mob.instance()
		add_child(mob)

		mob.translate(Vector3(rand_range(-25, 25), 1, rand_range(-25, 25)))
		mobs.push_front(mob)
		#mob.rotate_y(PI/2)

