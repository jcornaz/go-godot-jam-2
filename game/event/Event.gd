extends Node2D


export var TIMER_MAX = 15
export var event_scale = Vector2(10, 10)

var current_players = {}
var player_scores: Dictionary = {}

var timer_started = false

signal event_started
signal event_ended
signal count_down
signal player_scores
signal heal_player(player_id)


func _process(delta):
	emit_signal("count_down", $Timer.time_left)
	emit_signal("player_scores", player_scores)
	if (!$Timer.is_stopped() && !$Timer.paused):
		handle_event_area(delta)
		handle_players(delta)


func get_max_time():
	return TIMER_MAX


func initialize():
	emit_signal("event_started")
	$Area2D/CollisionShape2D.scale = event_scale
	$Area2D/ShapePolygon2D.scale = event_scale
	$Area2D/ShapePolygon2D.visible = true


func handle_event_area(delta):
	if ($Timer.time_left > 2.0):
		$Area2D/CollisionShape2D.scale -= (event_scale / TIMER_MAX * 0.5) * delta
		$Area2D/ShapePolygon2D.scale = $Area2D/CollisionShape2D.scale
	else:
		$Area2D/ShapePolygon2D.color = $Area2D/ShapePolygon2D.color.lightened(0.2)


func handle_players(delta):
	for player in current_players.keys():
		var player_modifier = current_players[player]
		player_scores[player] += player_modifier * 0.1
		current_players[player] += player_modifier * delta * 0.5


func _on_Timer_timeout():
	if (!player_scores.empty()):
		var winner_id = determine_winner()
		$Area2D/CollisionShape2D.disabled = true
		$Area2D.visible = false
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
		$Timer.set_paused(false)
	else:
		$Timer.start(TIMER_MAX)
		timer_started = true


func _on_Area2D_body_exited(body):
	current_players.erase(body.player_id)
	if (current_players.empty()):
		$Timer.set_paused(true)


func end_event():
	emit_signal("event_ended")
	self.queue_free()
