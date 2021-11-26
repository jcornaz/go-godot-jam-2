extends Node2D


func _ready():
	$HUD.set_player_max_health(1, $Players/Player1.INITIAL_HEALTH)
	$HUD.set_player_max_health(2, $Players/Player2.INITIAL_HEALTH)


func _on_MainMenu_game_started():
	$Players/Player1.reset_player(Vector2(-531.0, -1.0))
	$Players/Player2.reset_player(Vector2(448.0, 1.0))
	$HUD.reset()
