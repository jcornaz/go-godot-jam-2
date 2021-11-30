extends Node2D

func initialize(direction: Vector2):
	$Fireball.initialize(direction)

func _on_explode_peak():
	var scorched_ground = load("res://game/environment/Burning ground.tscn").instance()
	get_parent().add_child(scorched_ground)
	scorched_ground.global_position = $Fireball.global_position
	var ground = scorched_ground.get_child(0)
	ground.size = $Fireball.EXPLOSION_RADIUS
	
