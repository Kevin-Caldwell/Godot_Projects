extends Spatial

export (PackedScene) var Mob

var MOB_COUNT = 5
var mobs = []
var robot


func _ready():
	randomize()
	robot = $Robot
	

func _process(delta):

	if mobs.size() < MOB_COUNT:
		var mob = Mob.instance()
		add_child(mob)

		mob.translate(Vector3(rand_range(-25, 25), 1, rand_range(-25, 25)))
		mobs.push_front(mob)


