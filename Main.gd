extends Node


export var Arena: PackedScene setget _setArena

var _current_arena: Node

func _ready():
	$Tween.interpolate_property($Soundtrack, "volume_db", -50, -5, 5)
	$Tween.start()
	
func _on_game_started():
	if (_current_arena):
		_current_arena.queue_free()
	_current_arena = Arena.instance()
	add_child(_current_arena)
	_current_arena.connect("GameFinished", self, "_on_game_finished")


func _on_game_finished(num):
	$MainMenu.handle_player_death(str(num))

func _setArena(value):
	_current_arena = value.instance()
	add_child(_current_arena)
	Arena = value
