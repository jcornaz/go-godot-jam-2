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

func handle_player_death(player_id):
	print("TODO: call this function on emitted player death signal")
	$Menu/View/EndGameMessage.text = "Player " + player_id + " won!"
	$Menu/View/ItemList/StartGame.text = "Play Again"
	$Menu.show()
	get_tree().paused = true
