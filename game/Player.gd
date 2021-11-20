extends KinematicBody2D

enum PlayerId {
	Player1, Player2
}

export (PlayerId) var player_id
const SPEED = 15000

export var INITIAL_HEALTH = 100
var health = INITIAL_HEALTH

func _ready():
	if (player_id != PlayerId.Player1):
		remove_child($GUI_Player1)
	if (player_id != PlayerId.Player2):
		remove_child($GUI_Player2)

func _physics_process(delta):
	var velocity = Input.get_vector(
		str("move_left_player", player_id), 
		str("move_right_player", player_id), 
		str("move_up_player", player_id), 
		str("move_down_player", player_id))
	
	move_and_slide(velocity * delta * SPEED)

func hit_by_projectile(projectile):
	health -= 21.5
