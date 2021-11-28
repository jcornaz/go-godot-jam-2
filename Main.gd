extends Node


var Arena = preload("res://game/Arena.tscn")

onready var _current_arena = $Arena

func _on_game_started():
	_current_arena.queue_free()
	_current_arena = Arena.instance()
	add_child(_current_arena)
	_current_arena.connect("PlayerDied", self, "_on_PlayerDied")


func _on_PlayerDied(num):
	$MainMenu.handle_player_death(str(num))
