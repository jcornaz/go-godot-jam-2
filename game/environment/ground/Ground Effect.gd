tool
extends Node2D

signal on_ground_entered(Player)
signal on_ground_exited(Player)

export var color: Color setget set_color
export var size: int setget set_size

func _ready():
	set_color(color)
	set_size(size)

func set_color(value: Color):
	color = value
	var circle_texture = $CircleTexture
	if circle_texture:
		var box := (circle_texture.style_box as StyleBoxFlat)
		box.bg_color = color
		box.border_color = Color(color.r, color.g, color.b, color.a / 2)

func set_size(value: int):
	size = value
	var circle_texture = $CircleTexture
	if circle_texture:
		circle_texture.size = Vector2(value, value)
		var box := (circle_texture.style_box as StyleBoxFlat)
		var radius = value * 0.3
		box.corner_radius_bottom_left = radius
		box.corner_radius_bottom_right = radius
		box.corner_radius_top_left = radius
		box.corner_radius_top_right = radius

func _on_ground_entered(body):
	if body is Player:
		emit_signal("on_ground_entered", body)


func _on_ground_exited(body):
	if body is Player:
		emit_signal("on_ground_exited", body)
