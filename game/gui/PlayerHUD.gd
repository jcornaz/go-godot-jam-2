tool
extends CanvasLayer


onready var progress_bar = get_node("Player Anchor/Health Bar")
var slots = {0: $"Player Anchor/Slot 1", 1: $"Player Anchor/Slot 2"}

enum PlayerId { # duplicated from Player script
	Player1, Player2, Player3, Player4
}

export (PlayerId) var player_id setget _set_player_id 

func _set_player_id(value: int):
	player_id = value
	_update_label()
	

func _ready():
	_update_label()

func _update_label():
	var anchor: Control = $"Player Anchor"
	var player_label = $"Player Anchor/Player Label"
	if not player_label or not anchor:
		return # ready not yet run and not in tool
	
	player_label.text = "Player " + str(player_id + 1)
	if (player_id + 1) % 2 == 0:
		anchor.margin_left = -210
		anchor.anchor_left = 1.0
		anchor.anchor_right = 1.0
	else:
		anchor.margin_left = 0
		anchor.anchor_left = 0.0
		anchor.anchor_right = 0.0

func set_player_max_health(max_health: float):
	progress_bar.max_value = max_health

func _on_player_HealthChanged(health: float):
	progress_bar.value = health

func _on_player_EnergySet(slot_index: int, ability: Ability):
	var slot: TextureRect = slots[slot_index]
	slot.texture = ability.texture
	slot.visible = true

