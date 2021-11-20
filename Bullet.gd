extends Area2D

var color: Color setget set_color

func set_color(new_color):
	color = new_color
	$AnimatedSprite.modulate = new_color
