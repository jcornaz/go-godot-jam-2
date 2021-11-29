extends Node2D


func _on_fire_entered(body: Player):
	body.health -= 20


func _on_fire_exited(body: Player):
	body.health -= 30
