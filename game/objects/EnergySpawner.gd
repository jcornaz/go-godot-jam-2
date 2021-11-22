extends Area2D
class_name EnergySpawner

signal IsGrabbed

var _is_available = false

func _ready():
	$Sprite.visible = _is_available

func is_available():
	return _is_available

func take():
	_is_available = false
	$Sprite.visible = false
	$Timer.start()
	
func _on_Timer_timeout():
	_is_available = true
	$Sprite.visible = true
