extends KinematicBody2D

signal HealthChanged(new_health)

enum PlayerId {
	Player1, Player2
}

export (PlayerId) var player_id
const SPEED = 20000

export var INITIAL_HEALTH = 100
export var COLOR = "blue"
export var SHOOT_OFFSET = 40
export var BULLET_SPEED = 1000

var health = INITIAL_HEALTH setget set_health

export var Spark = preload("res://game/bullet/Spark.tscn")

var _current_spawner: EnergySpawner = null

export var PRIMARY_COOLDOWN = 0.1
var current_primary_cooldown = 0.0

export var SECONDARY_COOLDOWN = 0.1
var current_secondary_cooldown = 0.0

func _ready():
	$WispAnimation.play(COLOR)

func _physics_process(delta):
	var direction = Input.get_vector(
		str("move_left_player", player_id + 1), 
		str("move_right_player", player_id + 1), 
		str("move_up_player", player_id + 1), 
		str("move_down_player", player_id + 1)
	).normalized()
	
	move_and_slide(direction * delta * SPEED)

func _process(delta):
	print(current_primary_cooldown)
	if Input.get_action_strength(str("primary_fire_player", player_id + 1)) and current_primary_cooldown <= 0.0:
		current_primary_cooldown = PRIMARY_COOLDOWN
		firePrimary()
		
	if Input.get_action_strength(str("secondary_fire_player", player_id + 1)) and current_secondary_cooldown <= 0.0:
		current_secondary_cooldown = SECONDARY_COOLDOWN
		fireSecondary()
	
	if current_primary_cooldown > 0.0:
		current_primary_cooldown -= delta
		
	if current_secondary_cooldown > 0.0:
		current_secondary_cooldown -= delta

func _input(event):
	if _current_spawner and _current_spawner.is_available() and Input.is_action_just_pressed(str("primary_grab_player", player_id + 1)):
		_current_spawner.take()
	

func firePrimary():
	var direction = _get_aim_direction()

	if direction.length_squared() > 0.0:
		var spark = Spark.instance()
		get_parent().add_child(spark)
		spark.global_position = self.global_position + direction * SHOOT_OFFSET
		spark.initialize(Color.red, direction * BULLET_SPEED)

func fireSecondary():
	var direction = _get_aim_direction()

	if direction.length_squared() > 0.0:
		var spark = Spark.instance()
		get_parent().add_child(spark)
		spark.global_position = self.global_position + direction * SHOOT_OFFSET
		spark.initialize(Color.blue, direction * BULLET_SPEED)

func _get_aim_direction() -> Vector2:
	return Input.get_vector(
		str("aim_left_player", player_id + 1), 
		str("aim_right_player", player_id + 1), 
		str("aim_up_player", player_id + 1), 
		str("aim_down_player", player_id + 1)
	).normalized()

func set_health(new_health):
	health = new_health
	emit_signal("HealthChanged", health)


func _on_spawner_detected_entered(area):
	if area is EnergySpawner:
		_current_spawner = area


func _on_SpawnerDetector_area_exited(area):
	if area == _current_spawner:
		_current_spawner = null
