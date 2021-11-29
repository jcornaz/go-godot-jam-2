extends Node2D

func _on_ice_entered(body: Player):
	body.is_sliding = true


func _on_ice_exited(body: Player):
	body.is_sliding = false
	body.sliding_direction = null
