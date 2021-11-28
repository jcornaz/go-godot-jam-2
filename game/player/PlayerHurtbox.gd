extends Area2D


func deal_damage(amount: float):
	get_parent().health -= amount

func slow(amount: float, duration: float):
	get_parent().slow_effect =  { "amount": amount, "duration": duration }
