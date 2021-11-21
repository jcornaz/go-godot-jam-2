tool
class_name StyleBox2D extends Node2D

export var size: Vector2 = Vector2(50, 50) setget set_size

export (StyleBox) var style_box setget set_style_box

func _draw():
	draw_style_box(style_box, Rect2(position-(size/2.0), size))

func set_size(value: Vector2):
	size = value
	__on_style_box_changed()

func set_style_box(value: StyleBox):
	if style_box == value:
		__on_style_box_changed()
		return
	if style_box != null:
		style_box.disconnect("changed", self, "__on_style_box_changed")
	style_box = value
	if style_box != null:
		style_box.connect("changed", self, "__on_style_box_changed")
	__on_style_box_changed()

func __on_style_box_changed():
	update()
