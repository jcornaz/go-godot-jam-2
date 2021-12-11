extends ViewportContainer

var target: Player = null setget _set_target

func _set_target(value: Player):
	target = value
	var hud = $"Viewport/PlayerHUD"
	hud.player_id = target.player_id
	hud.set_player_max_health(target.INITIAL_HEALTH)
	value.connect("HealthChanged", hud, "_on_player_HealthChanged")
	value.connect("EnergySet", hud, "_on_player_EnergySet")

func initialize(world: World2D, player: Player):
	$Viewport.world_2d = world
	_set_target(player)
