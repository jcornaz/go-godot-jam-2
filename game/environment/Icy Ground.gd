extends Node2D

func _on_ice_entered(body: Player):
	print("slowing doown")
	body.is_sliding = true


func _on_ice_exited(body: Player):
	print("speeding up")
	body.is_sliding = false
	body.sliding_direction = null
