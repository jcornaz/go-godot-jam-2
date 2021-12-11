extends ViewportContainer

var target: Player = null setget _set_target

func _set_target(value: Player):
	target = value
	$"Viewport/PlayerHUD".player_id = target.player_id

func initialize(world: World2D, player: Player):
	$Viewport.world_2d = world
	_set_target(player)
