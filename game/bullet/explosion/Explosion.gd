extends AnimatedSprite

signal explosion_peak

const PEAK_FRAME = 2
const BASE_RADIUS  = 17.5

export(PackedScene) var SPAWN
export(int) var SPAWN_COUNT = 0

var _radius = BASE_RADIUS

func initialize(node: Node2D, radius: float, animation: String = "fire"):
	var scale = radius/BASE_RADIUS
	self.scale = Vector2(scale, scale)
	self.global_position = node.global_position
	_radius = radius
	play(animation)
	


func _count_to_the_peak():
	if frame == 2:
		emit_signal("explosion_peak")
		
		if SPAWN:
			for i in range(SPAWN_COUNT):
				var instance = SPAWN.instance()
				var direction = Vector2.RIGHT.rotated(2*i*PI / SPAWN_COUNT)
				add_child(instance)
				instance.global_position = global_position + direction * (_radius * 0.8)
				instance.initialize(direction)

func _explosion_finished():
	queue_free()
 
