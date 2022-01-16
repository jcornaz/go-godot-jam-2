extends Node2D

signal GameFinished(num)

var surviving_players = {1: "Player 1", 2: "Player 2", 3: "Player 3", 4: "Player 4"}

func _on_Player_Dead(player_num: int):
	surviving_players.erase(player_num)
	if surviving_players.keys().size() == 1:
		var player = surviving_players.keys()[0]
		emit_signal("GameFinished", player)


func _on_EventTimer_timeout():
	$Objects/Event.initialize()
	$HUD.set_event_max_time($Objects/Event.get_max_time())
