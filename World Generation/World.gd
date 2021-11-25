extends Spatial

var islandList = []

var islandCount = 500
var minDist = 500
var generationDistance = 3000

var islandScene
var islandCluster

func _ready():
	islandScene = preload("res://island.tscn")
	islandCluster = preload("res://IslandCluster.tscn")
	print("Scene is ready")
	generateWorld()
	
func _input(event):
	if Input.is_action_pressed("generateWorld"):
		pass
#		destroyWorld()
#		generateWorld()

func generateWorld():
	while(islandList.size() < islandCount):
		if(rand_range(1, 2) != 1):
			var newIsland = islandScene.instance()
			add_child(newIsland)
			newIsland.translate(generateIslandCoordinates())
			var scale = randf() * 100
			if scale < 5:
				scale = 5
			newIsland.scale = Vector3(scale, scale, scale)
			islandList.append(newIsland)
		else:
			var cluster = islandCluster.instance()
			add_child(cluster)
			cluster.translate(generateIslandCoordinates())
			var scale = randf() * 500
			if scale < 5:
				scale = 5
			cluster.scale = Vector3(scale, scale, scale)
			islandList.append(cluster)

func generateCluster():
	pass


func generateIslandCoordinates():
	var coords = Vector3(rand_range(0, generationDistance), rand_range(0, 200), rand_range(0, generationDistance))
	for island in islandList:
		if getDistance(coords, island.get_global_transform().origin) < 1:
			coords = generateIslandCoordinates()
	return coords

func getDistance(vec1 = Vector3(),  vec2 = Vector3()):
	return sqrt((vec1.x - vec2.x) * (vec1.x - vec2.x) + (vec1.z - vec2.z) * (vec1.z - vec2.z))

func destroyWorld():
	for island in islandList:
		island.queue_free()
	islandList = []

func _on_Button_pressed():
	generateWorld()

func getMin(num):
	return num
