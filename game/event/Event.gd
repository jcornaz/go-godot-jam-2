tool
extends Node2D
class_name Event


export var TIMER_MAX = 15
export var event_scale = Vector2(1, 1) setget _set_event_scale

var current_players = {}
var player_scores: Dictionary = {}

var timer_started = false

signal event_started
signal event_ended
signal count_down
signal player_scores(player_scores)
signal heal_player(player_id)

onready var style_box = $Texture/StyleBox2D
onready var collision_box = $Area2D/CollisionShape2D
onready var particles = $Texture/Particles2D
onready var timer = $Timer

func _ready():
	visible = false
	particles.emitting = false
	

func _process(delta):
	if not Engine.editor_hint:
		emit_signal("count_down", timer.time_left)
		emit_signal("player_scores", player_scores)
		if (!timer.is_stopped() && !timer.paused):
			handle_event_area(delta)
			handle_players(delta)


func get_max_time():
	return TIMER_MAX


func _set_event_scale(value):
	event_scale = value
	if $Area2D/CollisionShape2D:
		$Area2D/CollisionShape2D.scale = event_scale
		$Texture/StyleBox2D.scale = event_scale

func initialize():
	_set_event_scale(event_scale)
	particles.emitting = true
	start_event()
	visible = true


func handle_event_area(delta):
	if (timer.time_left > 1.0):
		collision_box.scale -= (event_scale / TIMER_MAX * 0.5) * delta
		style_box.scale = collision_box.scale
	else:
		var box: StyleBoxFlat = style_box.style_box
		box.border_color = box.border_color.darkened(0.01)


func handle_players(delta):
	for player in current_players.keys():
		var player_modifier = current_players[player]
		player_scores[player] += player_modifier * 0.1
		current_players[player] += player_modifier * delta * 0.5


func _on_Timer_timeout():
	if (!player_scores.empty()):
		var winner_id = determine_winner()
		collision_box.disabled = true
		visible = false
		emit_signal("heal_player", winner_id)
		end_event()


func determine_winner():
	if (player_scores.size() == 1):
		return player_scores.keys()[0]
	else:
		var first_score = player_scores[0]
		var second_score = player_scores[1]
		if (first_score > second_score):
			return player_scores.keys()[0]
		elif (first_score < second_score):
			return player_scores.keys()[1]
		else:
			return current_players.keys()[0]


func _on_Area2D_body_entered(body):
	current_players[body.player_id] = 0.1
	if (!player_scores.has(body.player_id)):
		player_scores[body.player_id] = 0.0
		
	if (timer_started):
		timer.set_paused(false)
	else:
		timer.start(TIMER_MAX)
		timer_started = true


func _on_Area2D_body_exited(body):
	current_players.erase(body.player_id)
	if (current_players.empty()):
		timer.set_paused(true)

func start_event():
	GlobalBus.register_event(self)
	emit_signal("event_started")

func end_event():
	emit_signal("event_ended")
	GlobalBus.unregister_event(self)
	self.queue_free()
