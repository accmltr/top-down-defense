extends Node

class_name EnemiesMan

var enemies: Array = []

func setup():
	for c in get_children():
		enemies.append(c)

func add_enemy(e: Enemy):
	if e.get_parent():
		e.get_parent().remove_child(e)
	add_child(e)
	enemies.append(e)

func delete_enemy(e: Enemy):
	enemies.erase(e)
	e.queue_free()
