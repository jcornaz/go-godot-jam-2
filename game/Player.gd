extends KinematicBody2D

export var player_id: int = 1
const SPEED = 15000

func _physics_process(delta):
	var velocity = Input.get_vector(
		str("move_left_player", player_id), 
		str("move_right_player", player_id), 
		str("move_up_player", player_id), 
		str("move_down_player", player_id))
	
	move_and_slide(velocity * delta * SPEED)
