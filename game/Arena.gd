extends Node2D


func _ready():
	$HUD.set_player_max_health(1, $Players/Player1.INITIAL_HEALTH)
	$HUD.set_player_max_health(2, $Players/Player2.INITIAL_HEALTH)

