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
