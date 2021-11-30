extends Node2D

var burning_players: Array = [] # Array<Player>


func _process(delta):
	for player in burning_players:
		(player as Player).burn_effect = { "amount": 5.0, "duration": 4.0 }


func _on_fire_entered(body: Player):
	burning_players.append(body)
	body.display_damage_taken()


func _on_fire_exited(body: Player):
	var index = burning_players.find(body)
	burning_players.remove(index)
