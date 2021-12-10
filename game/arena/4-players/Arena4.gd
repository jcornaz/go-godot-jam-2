extends Node2D

signal GameFinished(num)

func _ready():
	pass
	#$HUD.set_player_max_health(1, $Players/Player1.INITIAL_HEALTH)
	#$HUD.set_player_max_health(2, $Players/Player2.INITIAL_HEALTH)


func _on_Player_Dead(player_num: int):
	emit_signal("GameFinished", player_num)


func _on_EventTimer_timeout():
	$Objects/Event.initialize()
	$HUD.set_event_max_time($Objects/Event.get_max_time())
