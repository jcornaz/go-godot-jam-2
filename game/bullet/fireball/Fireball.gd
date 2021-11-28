extends RigidBody2D

export var EXPLOSION: PackedScene
export var EXPLOSION_RADIUS: float = 100
export var DAMAGE: int = 20
export var SPEED = 1000

var exploded = false

func _ready():
	($ExplosionHitbox/CollisionShape2D.shape as CircleShape2D).radius = EXPLOSION_RADIUS
	$AnimatedSprite.play()

func initialize(direction: Vector2):
	apply_impulse(Vector2.ZERO, direction * SPEED * mass)
	rotation = direction.angle()

func _on_Hitbox_entered(area):
	_on_explode()


func _on_body_entered(body):
	_on_explode()


func _on_explode():
	if exploded == false:
		exploded = true
		sleeping = true
		var explosion = EXPLOSION.instance()
		get_parent().add_child(explosion)
		explosion.initialize(self, EXPLOSION_RADIUS)
		explosion.connect("explosion_peak", self, "_on_explode_peak")
	

func _on_explode_peak():
	var hitPlayerHurtBoxes = $ExplosionHitbox.get_overlapping_areas()
	for hitPlayerHurtBox in hitPlayerHurtBoxes:
		hitPlayerHurtBox.deal_damage(DAMAGE)
	queue_free()
