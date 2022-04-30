extends Projectile

var _speed: float = 70

func _physics_process(delta):
	if MapRefs.map.has_enemy(_target):
		global_position = global_position.move_toward(_target.global_position, _speed*delta)
	elif _launched:
		destroy()

func launch(manager, damage_: float, target_: Node2D):
	.launch(manager, damage_, target_)


func _on_body_entered(body):
	print("deal %s damage to %s" % [_damage, body])
	destroy()
