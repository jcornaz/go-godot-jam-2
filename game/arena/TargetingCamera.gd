extends Camera2D

var target: Player = null

func _physics_process(delta):
	if target:
		var direction = target.get_aim_direction()
		position = target.position + (direction * 300)
