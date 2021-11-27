extends AnimatedSprite

signal explosion_peak

const PEAK_FRAME = 2
const BASE_RADIUS  = 17.5

func initialize(node: Node2D, radius: float):
	var scale = radius/BASE_RADIUS
	self.scale = Vector2(scale, scale)
	self.global_position = node.global_position
	play()


func _count_to_the_peak():
	if frame == 2:
		emit_signal("explosion_peak")

func _explosion_finished():
	queue_free()
