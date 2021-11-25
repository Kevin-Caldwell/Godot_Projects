extends Spatial

var islandScene = preload("res://island.tscn")
var islands = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	var mainIsland = islandScene.instance()
	var scaleI = randf() * 100
	print("island")
	mainIsland.get_transform().scaled(Vector3(scaleI, scaleI, scaleI))
	var sisterCount = rand_range(1, 10)
	for i in range(sisterCount):
		var sister = islandScene.instance()
		add_child(sister)
		var scale = randf()
		sister.get_transform().scaled(Vector3(scale, scale, scale))
		sister.translate(Vector3(rng.randf_range(-1, 1), rng.randf_range(-1, 1), rng.randf_range(-1, 1)))
