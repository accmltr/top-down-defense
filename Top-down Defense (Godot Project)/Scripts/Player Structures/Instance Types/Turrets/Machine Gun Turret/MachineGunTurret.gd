extends Turret

class_name MachineGunTurret

# warning-ignore:unused_argument
func _physics_process(delta):
	if MapRefs.map.has_enemy(attacker_part.target):
		look_at(attacker_part.target.global_position)
	else:
		# do idle animations
		pass
