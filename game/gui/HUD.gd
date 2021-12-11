extends CanvasLayer


func set_player_max_health(player_num: int, max_health: float):
	var bar: ProgressBar = get_node(str("Player_", player_num, "/ProgressBar"))
	bar.max_value = max_health


func _on_player_HealthChanged(health: float, player_num: int):
	var bar: ProgressBar = get_node(str("Player_", player_num, "/ProgressBar"))
	bar.value = health


func _on_player_EnergySet(slot: int, ability: Ability, player_num: int):
	print(str("player ", player_num, " conjured ", ability, " on slot ", slot))
	var texture: TextureRect = get_node(str("Player_", player_num, "/Slot", slot))
	texture.texture = ability.texture
	texture.visible = true


func set_event_max_time(max_time: float):
	$Event/ProgressBar.max_value = max_time


func _on_Event_event_ended():
	$Event.visible = false
	$Event/ProgressBar.value = $Event/ProgressBar.max_value


func _on_Event_event_started():
	$Event.visible = true


func _on_Event_count_down(time: float):
	$Event/ProgressBar.value = time


func _on_Event_player_scores(player_scores: Dictionary):
	if (player_scores.has(0)):
		$Event/Player_1_Score.text = str(round(player_scores.get(0)))
	if (player_scores.has(1)):
		$Event/Player_2_Score.text = str(round(player_scores.get(1)))
