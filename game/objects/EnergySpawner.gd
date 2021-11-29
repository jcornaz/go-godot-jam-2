extends Area2D
class_name EnergySpawner

signal IsGrabbed

var _is_available = false
export(Resource) var element # type: Element

func _ready():
	$Sprite.modulate = element.color 
	$Sprite.visible = _is_available
	$Sprite.play()

func is_available():
	return _is_available

func take():
	if not _is_available:
		return null

	$PickupSound.play()
	_is_available = false
	$Sprite.visible = false
	$Timer.start()
	return element
	
func _on_Timer_timeout():
	_is_available = true
	$Sprite.visible = true
