extends Node2D

export var lower_position: Vector2
export var upper_position: Vector2

export var ice_effect: PackedScene
export var fire_effect: PackedScene

export var ICE_SPAWN_FREQUENCY = 8.0
export var ICE_DURATION = 14.0
export var FIRE_SPAWN_FREQUENCY = 8.0
export var FIRE_DURATION = 14.0

var random_generator = RandomNumberGenerator.new()

var ice_spawn_timer = 0.0
var fire_spawn_timer = 0.0
var despawn_counter = 0.0
var spawned_effects = []

enum EFFECTS { ICE, FIRE }

func _ready():
	random_generator.randomize()

func _process(delta):
	ice_spawn_timer += delta
	if (ice_spawn_timer >= ICE_SPAWN_FREQUENCY):
		_spawn_environmental_effect(EFFECTS.ICE)
		ice_spawn_timer = 0.0
	
	fire_spawn_timer += delta
	if (fire_spawn_timer >= FIRE_SPAWN_FREQUENCY):
		_spawn_environmental_effect(EFFECTS.FIRE)
		fire_spawn_timer = 0.0
	
	despawn_counter += delta
	_handle_despawn()

func _handle_despawn():
	var next_effect = spawned_effects.front()
	if (next_effect):
		var effect = next_effect["effect"]
		var time: float = next_effect["time"]
		if (time < despawn_counter):
			spawned_effects.pop_front()
			effect.despawn()

func _spawn_environmental_effect(effect_type: int):
	var effect_scene = null
	var duration = 0.0
	if (effect_type == EFFECTS.ICE):
		effect_scene = ice_effect
		duration = ICE_DURATION
	if (effect_type == EFFECTS.FIRE):
		effect_scene = fire_effect
		duration = FIRE_DURATION
	
	var effect: Node2D = effect_scene.instance()
	var x = random_generator.randi_range(lower_position.x, upper_position.x)
	var y = random_generator.randi_range(lower_position.y, upper_position.y)
	effect.position = Vector2(x, y)
	add_child(effect)
	spawned_effects.append({"effect": effect, "time": despawn_counter + duration})
