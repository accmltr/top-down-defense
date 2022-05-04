extends Projectile

class_name SimpleProjectile

# A projectile used by enemies and turrets. Simply flies to target at a set speed, and applies damage on hit.

export var _speed: float = 70

signal hit(target)

func _physics_process(delta):
	if MapRefs.map.has_enemy(_target):
		global_position = global_position.move_toward(_target.global_position, _speed*delta)
	elif _launched:
		destroy()

func launch(manager, damage_: float, target_: Node2D = null):
	.launch(manager, damage_, target_)


func _on_body_entered(body):
	if body == _target:
		print("deal %s damage to %s" % [_damage, body])
		emit_signal("hit", _target)
		destroy()
