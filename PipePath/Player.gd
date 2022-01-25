extends KinematicBody2D

signal reachedJunction

# 2D Vector which stores the position of the Sprite
var velocity = Vector2()

# Junction variables which store previous and next Junction
var previousJunction
var nextJunction

var moving = false

var speed = 90

var path = []
var instances = []

func _ready():
	pass

func _physics_process(_delta):
	if moving:
		
		# Rotates and moves Sprite toward the next Junction
		look_at(nextJunction.position)
		velocity = Vector2(speed, 0).rotated(rotation)
		
		velocity = move_and_slide(velocity)
		
		# Check for determining if Character has reached a node
		if (position - nextJunction.position).length() < 1:

			var pathFound = false
			
			# If the path list does not contain a connected junction, that 
			# junction will be used as the next Junction
			for junction in nextJunction.connections:
				
				# 
				if !path.has(junction):
					path.append(nextJunction.index)
					previousJunction = nextJunction
					nextJunction = instances[junction]

					pathFound = true
					previousJunction.movable = false
					nextJunction.movable = false
					break

			if !pathFound:
				previousJunction = nextJunction
				if nextJunction.index != get_parent().endJunction:
					moving = false
					print("Game over.")
					get_parent().get_node("GameEndColorRect").color = Color(255, 0, 0, 255)
					get_parent().get_node("GameEndLabel").text = "You Lose."

			if previousJunction.index == get_parent().endJunction:
				moving = false
				print("You win!!")
				$Icon/Crown.visible = true
				get_parent().get_node("GameEndColorRect").color = Color(0, 255, 0, 255)
				get_parent().get_node("GameEndLabel").text = "You Won!"


# Event Handler which starts when Timer ends
func _on_Timer_timeout():
	moving = true
