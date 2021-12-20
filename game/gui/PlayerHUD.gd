tool
extends CanvasLayer


onready var health_bar = get_node("Player Anchor/Health Bar")
onready var event_bar = get_node("Player Anchor/Event Bar")
onready var slots = {1: $"Player Anchor/Slot 1", 2: $"Player Anchor/Slot 2"}

enum PlayerId { # duplicated from Player script
	Player1, Player2, Player3, Player4
}

export (PlayerId) var player_id setget _set_player_id 

func _set_player_id(value: int):
	player_id = value
	_update_label()

func _ready():
	_update_label()
	
	GlobalBus.connect("event_registered", self, "_register_event")
	GlobalBus.connect("event_unregistered", self, "_unregister_event")

func _register_event(event: Event):
	event.connect("player_scores", self, "_set_player_score")
	event_bar.visible = true

func _unregister_event(event: Event):
	event.disconnect("player_scores", self, "_set_player_score")
	event_bar.visible = false

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
	health_bar.max_value = max_health

func _on_player_HealthChanged(health: float):
	health_bar.value = health

func _on_player_EnergySet(slot_index: int, ability: Ability):
	var slot: TextureRect = slots[slot_index]
	slot.texture = ability.texture
	slot.visible = true

func _set_player_score(player_scores: Dictionary):
	var total_score = 0.0
	for score in player_scores.values():
		total_score += score
	if total_score == 0.0:
		event_bar.max_value = 100.0
	else:
		event_bar.max_value = total_score
	print("max_score (" + str(player_id)+ ") = " + str(total_score))
	
	var player_score = 0.0
	if player_id in player_scores:
		player_score = player_scores[player_id]
	event_bar.value = player_score
	print("score (" + str(player_id)+ ") = " + str(player_score))
	
