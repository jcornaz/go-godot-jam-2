extends CanvasLayer


signal game_started

func _ready():
	get_tree().paused = true
	$Menu/View/ItemList/StartGame.grab_focus()


func _on_StartGame_pressed():
	$Menu.hide()
	emit_signal("game_started")
	get_tree().paused = false


func _on_EndGame_pressed():
	get_tree().quit()


func handle_player_death(player_id: String):
	handle_game_finished("Player " + player_id + " perished!")


func handle_player_win(player_id: String):
	handle_game_finished("Player " + player_id + " won!")


func handle_game_finished(message: String):
	$Menu/View/EndGameMessage.text = message
	$Menu/View/ItemList/StartGame.text = "Play Again"
	$Menu/View/ItemList/StartGame.grab_focus()
	$Menu.show()
	get_tree().paused = true


func _on_Player_HealthChanged(health: float, player_num: int):
	if (health <= 0.0):
		handle_player_death(str(player_num))
		get_tree().call_group("Bullet", "queue_free")


func show_controls():
	$Menu/ControlsPanel.show()
	$Menu/View/ItemList/StartGame.disabled = true
	$Menu/View/ItemList/ShowControls.disabled = true
	$Menu/View/ItemList/EndGame.disabled = true
	$Menu/ControlsPanel/ControlsView/Back.disabled = false
	$Menu/ControlsPanel/ControlsView/Back.grab_focus()


func hide_controls():
	$Menu/ControlsPanel.hide()
	$Menu/View/ItemList/StartGame.disabled = false
	$Menu/View/ItemList/ShowControls.disabled = false
	$Menu/View/ItemList/EndGame.disabled = false
	$Menu/ControlsPanel/ControlsView/Back.disabled = true
	$Menu/View/ItemList/StartGame.grab_focus()


func _on_ShowControls_pressed():
	show_controls()


func _on_Button_pressed():
	hide_controls()
