extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var jetPackScene = preload("res://Robot/Jetpack/Jetpack.tscn")
var jetpack
# Called when the node enters the scene tree for the first time.
func _ready():
	jetpack = jetPackScene.instance()
	add_child(jetpack)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
