extends RigidBody2D


export var SPEED = 1000

func initialize(direction: Vector2):
	apply_impulse(Vector2.ZERO, direction * SPEED * mass)
	rotation = direction.angle()


func _on_Hitbox_entered(area):
	area.deal_damage(5)
	queue_free()


func _on_body_entered(body):
	queue_free()
