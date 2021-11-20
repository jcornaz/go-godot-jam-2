extends KinematicBody2D

enum PlayerId {
	Player1, Player2
}

export (PlayerId) var player_id
const SPEED = 15000

export var INITIAL_HEALTH = 100
var health = INITIAL_HEALTH

func _ready():
	_hide_other_player_huds()
	_update_health_indicators()

func _physics_process(delta):
	var velocity = Input.get_vector(
		str("move_left_player", player_id + 1), 
		str("move_right_player", player_id + 1), 
		str("move_up_player", player_id + 1), 
		str("move_down_player", player_id + 1))
	
	if (Input.is_action_just_pressed("ui_accept")):
		hit_by_projectile(null)
	
	move_and_slide(velocity * delta * SPEED)

func hit_by_projectile(projectile):
	health -= 20.0
	_update_health_indicators()

func _update_health_indicators():
	if (player_id == PlayerId.Player1):
		_update_health_indicator($HUD/HUD_Player1/ProgressBar)
	if (player_id == PlayerId.Player2):
		_update_health_indicator($HUD/HUD_Player2/ProgressBar)

func _update_health_indicator(health_indicator: ProgressBar):
	health_indicator.value = health
	health_indicator.max_value = INITIAL_HEALTH

func _hide_other_player_huds():
	if (player_id != PlayerId.Player1):
		$HUD/HUD_Player1.visible = false
	if (player_id != PlayerId.Player2):
		$HUD/HUD_Player2.visible = false
