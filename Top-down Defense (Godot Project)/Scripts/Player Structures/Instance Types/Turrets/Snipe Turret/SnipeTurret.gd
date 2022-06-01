extends Turret

class_name SnipeTurret

# warning-ignore:unused_argument
func _physics_process(delta):
	if is_enemy_alive(attacker_part.target):
		look_at(attacker_part.target.global_position)
	else:
		# do idle animations
		pass
