extends Node2D


export var TIMER_MAX = 15
export var event_scale = Vector2(10, 10)

var current_players = {}
var player_scores: Dictionary = {}

var timer_started = false


func _process(delta):
	if (!$Timer.is_stopped() && !$Timer.paused):
		handle_event_area(delta)
		handle_players(delta)
		print("Timer up")
	else:
		print("Timer down")


func initialize_event(start_pos: Vector2):
	position = start_pos
	$Area2D/CollisionShape2D.scale = event_scale
	$Area2D/ShapePolygon2D.scale = event_scale
	$Area2D/ShapePolygon2D.color = Color.white
	$Area2D/ShapePolygon2D.color.a = 0.5


func handle_event_area(delta):
	if ($Timer.time_left > 2.0):
		$Area2D/CollisionShape2D.scale -= (event_scale / TIMER_MAX) * delta
		$Area2D/ShapePolygon2D.scale = $Area2D/CollisionShape2D.scale
	else:
		$Area2D/ShapePolygon2D.color = $Area2D/ShapePolygon2D.color.darkened(0.2)


func handle_players(delta):
	for player in current_players.keys():
		var player_modifier = current_players[player]
		player_scores[player] += player_modifier * 0.1
		current_players[player] += player_modifier * delta


func _on_Timer_timeout():
	# todo: determine winner, spawn/generate reward
	$Area2D/CollisionShape2D.disabled = true
	queue_free()


func _on_Area2D_body_entered(body):
	current_players[body.player_id] = 0.1
	if (!player_scores.has(body.player_id)):
		player_scores[body.player_id] = 0.0
		
	if (timer_started):
		$Timer.set_paused(false)
	else:
		$Timer.start(TIMER_MAX)
		timer_started = true


func _on_Area2D_body_exited(body):
	current_players.erase(body.player_id)
	if (current_players.empty()):
		$Timer.set_paused(true)
