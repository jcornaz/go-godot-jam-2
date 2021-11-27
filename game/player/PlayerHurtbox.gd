extends Area2D


func deal_damage(amount: float):
	get_parent().health -= amount
