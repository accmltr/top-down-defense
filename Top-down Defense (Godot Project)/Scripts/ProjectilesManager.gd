extends Node

class_name ProjectilesManager

var projectiles: Array = []

func add_projectile(p: Projectile):
	if p.get_parent():
		p.get_parent().remove_child(p)
	add_child(p)
	projectiles.append(p)

func delete_projectile(p: Projectile):
	projectiles.remove(projectiles.find(p))
	p.queue_free()

func has_projecttile(p: Projectile) -> bool:
	return projectiles.has(p)
