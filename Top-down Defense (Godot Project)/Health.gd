extends Node

class_name Health

export var max_health = 100

onready var health = max_health

signal die(attacker)

func change_health(attacker_: Node2D, c_: float):
	health = clamp(health + c_, 0, max_health)
	if health == 0:
		emit_signal("die", attacker_)
