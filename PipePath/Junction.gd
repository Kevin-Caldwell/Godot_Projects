extends Area2D

var index = 0
var length = 0
var angle = 0
var movable = true

var connections = []

func _ready():
	pass
	
# Junction rotates counter-clockwise when left-clicked and clockwise when right-clicked
func _on_Junction_input_event(viewport, event, shape_idx):
	if movable:
		if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
			angle += 90
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
			angle -= 90

# Rotation Animation
func _process(delta):
	if rotation_degrees < angle:
		rotation_degrees += 4
	if rotation_degrees > angle:
		rotation_degrees -= 4
	if abs(rotation_degrees - angle) < 5:
		rotation_degrees = angle
		if angle == 360:
			angle = 0
			rotation_degrees = 0
	 rotation_degrees = round(rotation_degrees)
	#$Label.text = str(rotation_degrees)
	
# Detection for connection made
func _on_Area2D_area_entered(area):
	if !area.get_parent().connections.has(index):
		area.get_parent().connections.append(index)
	

# Detection for connection lost
func _on_Area2D_area_exited(area):
	area.get_parent().connections.remove(area.get_parent().connections.find(index))
