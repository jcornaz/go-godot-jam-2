extends RigidBody2D

export var DAMAGE: int = 30
export var SPEED = 2000


func initialize(direction: Vector2):
	apply_impulse(Vector2.ZERO, direction * SPEED * mass)
	rotation = direction.angle()

func _on_Hitbox_area_entered(area):
	area.deal_damage(DAMAGE)
	queue_free()


func _on_IceSpike_body_entered(body):
	queue_free()
