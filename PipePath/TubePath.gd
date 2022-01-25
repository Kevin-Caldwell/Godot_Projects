extends Node2D

# Junction Dimensions:
var length = 4
var width = 5

# List of instances, useful for easy storage and retrieval 
var instances = []
# List of indeces used to store a chain on connections between pipes
var connectionChain = []

# Indeces of the start and end junction
var startJunction = 0
var endJunction = 0

var gameIsRunning = false

# Juction Scene Selector
export (PackedScene) var junctionScene

var rng = RandomNumberGenerator.new()

# Default function called when node is initialized
func _ready():
	# Creates Randomness. without this line, the same seed is used 
	randomize()
	
	# Nested for loop to create and arrange 
	for i in range(width):
		for j in range(length):
			
			var junction = junctionScene.instance()
			add_child(junction)
			
			if i == 0 and j == 0:
				junction.get_node("AnimatedSprite").set_animation("start")
			
			junction.index = j + i * length
			junction.length = length
			instances.append(junction)
			
			junction.position.x = 80 + i * 140
			junction.position.y = 90 + j * 140
			
			junction.scale.x = 0.145
			junction.scale.y = 0.145
			
			junction.angle = 90 * rng.randi_range(-1, 2)
	# Game Start conditions
	startJunction = 0
	$Player.position = instances[startJunction].position
	$Player.previousJunction = instances[startJunction]
	$Player.nextJunction = instances[startJunction]
	$Player.instances = instances
	
	endJunction = int(getRandomInteger(0, length * width - 1, startJunction))
#	while endJunction == startJunction:
#		endJunction = int(rand_range(1, length * width - 1))
	instances[endJunction].get_node("AnimatedSprite").set_animation("end")

# Counter variable for checking for connections on the 10th frame
var counter = 0

# Function called every frame
func _process(_delta):
	
	if gameIsRunning:
		if $Player/Timer.time_left == 0:
			$TimerLabel.text = "Character has started moving."
		else:
			$TimerLabel.text = "Character moves in: " + str(round($Player/Timer.time_left)) + " seconds"
	
	counter+=1
	
	# Update ConnectionChain with current connections
	if (counter % 10 == 0):
		
		connectionChain.clear()
		connectionChain.append(startJunction)
		
		for junctionIndex in connectionChain:
			for connection in instances[junctionIndex].connections:
				if !connectionChain.has(connection):
					connectionChain.append(connection)
		for i in range(instances.size()):
			
			# set_animation(name) is the method of an  animation node used to cycle through sprites 
			if connectionChain.has(i):
				if i == startJunction:
					instances[i].get_node("AnimatedSprite").set_animation("start")
				elif i == endJunction:
					instances[i].get_node("AnimatedSprite").set_animation("EndJunctionConnected")
				else:
					instances[i].get_node("AnimatedSprite").set_animation("junctionConnected")
			else:
				if i != endJunction:
					instances[i].get_node("AnimatedSprite").set_animation("default")
				else:
					instances[i].get_node("AnimatedSprite").set_animation("end")

# Function which is called when the game recieves an input
func _input(event):
	
	# Start the game when mouse is clicked
	if event is InputEventMouseButton:
		if !gameIsRunning:
			gameIsRunning = true
			$Player.get_node("Timer").start()
			

func _onSpeedHSliderValueChanged(value):
	$Player.speed = value


func _onStartButtonClicked():
	gameIsRunning = false
	
	startJunction = $Player.previousJunction.index
	endJunction = getRandomInteger(1, length * width - 1, startJunction)
	# junctions reset
	instances[endJunction].get_node("AnimatedSprite").set_animation("end")
	instances[startJunction].get_node("AnimatedSprite").set_animation("start")
	connectionChain.clear()
	
	for junction in instances:
		junction.get_node("AnimatedSprite").set_animation("default")
		junction.movable = true
		junction.angle = 90 * rng.randi_range(-1, 2)
	
	# Player Reset
	$Player/Icon/Crown.visible = false
	$Player.previousJunction = instances[startJunction]
	$Player.nextJunction = instances[startJunction]
	$Player.position = instances[startJunction].position
	$Player.path.clear()
	$Player.moving = false
	
	$TimerLabel.text = "Click to Start the game"
	$GameEndLabel.text = ""
	$GameEndColorRect.color = Color(0, 130, 136, 255)

# Returns a random number which is not equal to the value to be avoided
func getRandomInteger(lowerBound = 0, upperBound = 0, avoidValue = 1):
	var randNum = rng.randi_range(lowerBound, upperBound)
	while randNum == avoidValue:
		randNum = rng.randi_range(lowerBound, upperBound)
	return randNum


func _onHowToPlayButtonUp():
	$Popup.popup()
