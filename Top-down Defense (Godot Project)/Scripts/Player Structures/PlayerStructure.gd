extends Node2D

class_name PlayerStructure

var max_health: float = 100
var cur_health: float = max_health
onready var radius: float = $CollisionShape2D.shape.radius

func destroy():
	queue_free()

func change_health(change: float):
	cur_health = clamp(cur_health + change, 0, max_health)
	if cur_health <= 0:
		destroy()

func is_enemy_alive(enemy):
	return MapRefs.enemies_manager().enemies.has(enemy)
