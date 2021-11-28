extends Node2D

signal PlayerDied(num)

func _ready():
	$HUD.set_player_max_health(1, $Players/Player1.INITIAL_HEALTH)
	$HUD.set_player_max_health(2, $Players/Player2.INITIAL_HEALTH)


func _on_Player_Dead(player_num: int):
	emit_signal("PlayerDied", player_num)
