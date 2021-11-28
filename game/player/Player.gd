extends KinematicBody2D

signal HealthChanged(new_health)
signal EnergySet(slot, element)

enum PlayerId {
	Player1, Player2
}

export (PlayerId) var player_id
const SPEED = 20000

export var INITIAL_HEALTH = 100
export var COLOR = "blue"
export var SHOOT_OFFSET = 40

var health = INITIAL_HEALTH setget set_health
var slow_effect: Dictionary = {} #Dict<"amount": float, "duration": float>

export var Spark = preload("res://game/bullet/spark/Spark.tscn")

var _current_spawner: EnergySpawner = null

var _cooldown := 0.0

var _element_a: Dictionary = {} #Dict<Slot, Element>
var _element_b: Dictionary = {} #Dict<Slot, Element>
var _abilities: Dictionary = {} #Dict<Slot, Ability>

enum Slot { PRIMARY, SECONDARY }

func _ready():
	$WispAnimation.play(COLOR)
	reset_player(position)

func reset_player(pos: Vector2):
	self.position = pos
	set_health(INITIAL_HEALTH)
	_element_a.clear()
	_element_b.clear()
	_abilities.clear()
	var slot1 = Slot.PRIMARY
	_abilities[slot1] = _combine_elements(_element_a.get(slot1), _element_b.get(slot1))
	var slot2 = Slot.SECONDARY
	_abilities[slot2] = _combine_elements(_element_a.get(slot2), _element_b.get(slot2))
	slow_effect = { "amount": 0.0, "duration": 0.0 }


func _physics_process(delta):
	var direction = Input.get_vector(
		str("move_left_player", player_id + 1), 
		str("move_right_player", player_id + 1), 
		str("move_up_player", player_id + 1), 
		str("move_down_player", player_id + 1)
	).normalized()
	
	var current_speed = SPEED
	if slow_effect["amount"]  > 0.0:
		current_speed *= slow_effect["amount"] 
	move_and_slide(direction * delta * current_speed)

func _process(delta):
	if Input.get_action_strength(str("primary_fire_player", player_id + 1)) and _cooldown <= 0.0:
		fire(Slot.PRIMARY)
		
	if Input.get_action_strength(str("secondary_fire_player", player_id + 1)) and _cooldown <= 0.0:
		fire(Slot.SECONDARY)
	
	if _cooldown > 0.0:
		_cooldown -= delta
	
	if slow_effect["amount"] > 0.0:
		if slow_effect["duration"] > 0.0:
			slow_effect["duration"] -= delta
		else:
			slow_effect["amount"] = 0.0

func _input(event):
	if _current_spawner:
		
		if Input.is_action_just_pressed(str("primary_grab_player", _player_num())):
			var element: Element = _current_spawner.take()
			if element:
				_slot_energy(Slot.PRIMARY, element)
		
		if Input.is_action_just_pressed(str("secondary_grab_player", _player_num())):
			var element: Element = _current_spawner.take()
			if element:
				_slot_energy(Slot.SECONDARY, element)

func _slot_energy(slot: int, element: Element):
	if (not _element_a.has(slot)):
		_element_a[slot] = element
	elif (not _element_b.has(slot)):
		_element_b[slot] = element
	_abilities[slot] = _combine_elements(_element_a.get(slot), _element_b.get(slot))
	emit_signal("EnergySet", slot + 1, _abilities[slot])

const ABILITY_SPARK = preload("res://game/bullet/resources/ability_spark.tres")
const ABILITY_FIREBALL = preload("res://game/bullet/resources/ability_fireball.tres")
const ABILITY_ICEWAVE = preload("res://game/bullet/resources/ability_icewave.tres")

const ELEMENT_FIRE = preload("res://game/bullet/resources/element_fire.tres")
const ELEMENT_COLD = preload("res://game/bullet/resources/element_cold.tres")

func _combine_elements(element_a: Element, element_b: Element) -> Ability:
	if (element_a and element_a.name == ELEMENT_COLD.name):
		return ABILITY_ICEWAVE
	elif (element_a and element_a.name == ELEMENT_FIRE.name):
		return ABILITY_FIREBALL
	else: 
		return ABILITY_SPARK

func _player_num():
	return player_id + 1

func fire(slot: int):
	var direction = _get_aim_direction()

	if direction.length_squared() > 0.0:
		var ability: Ability = _abilities[slot]
		_cooldown = ability.cooldown
		var bullet = ability.bullet.instance()
		get_parent().add_child(bullet)
		bullet.global_position = self.global_position + direction * SHOOT_OFFSET
		bullet.initialize(direction)
		$ShootSound.play()

func _get_aim_direction() -> Vector2:
	return Input.get_vector(
		str("aim_left_player", player_id + 1), 
		str("aim_right_player", player_id + 1), 
		str("aim_up_player", player_id + 1), 
		str("aim_down_player", player_id + 1)
	).normalized()

func set_health(new_health):
	if new_health < health:
		$HurtSound.play()
		$AnimationPlayer.play("Hurt")
	
	health = new_health
	emit_signal("HealthChanged", health)


func _on_spawner_detected_entered(area):
	if area is EnergySpawner:
		_current_spawner = area


func _on_SpawnerDetector_area_exited(area):
	if area == _current_spawner:
		_current_spawner = null
