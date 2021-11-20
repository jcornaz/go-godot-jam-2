extends KinematicBody2D

const MAX_SPEED = 10000

func _physics_process(delta):
	var velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	move_and_slide(velocity * delta * MAX_SPEED)
	
	
