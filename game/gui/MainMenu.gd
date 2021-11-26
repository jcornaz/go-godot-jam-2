extends CanvasLayer


signal game_started

func _ready():
	get_tree().paused = true

func _on_StartGame_pressed():
	$Menu.hide()
	emit_signal("game_started")
	get_tree().paused = false


func _on_EndGame_pressed():
	get_tree().quit()


func handle_player_death(player_id: String):
	$Menu/View/EndGameMessage.text = "Player " + player_id + " perished!"
	$Menu/View/ItemList/StartGame.text = "Play Again"
	$Menu.show()
	get_tree().paused = true


func _on_Player_HealthChanged(health: float, player_num: int):
	if (health <= 0.0):
		handle_player_death(str(player_num))
