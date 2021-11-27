extends RigidBody2D


func initialize(velocity: Vector2):
	apply_impulse(Vector2.ZERO, velocity * mass)


func _on_Hitbox_entered(area):
	area.deal_damage(5)
	queue_free()


func _on_body_entered(body):
	queue_free()
