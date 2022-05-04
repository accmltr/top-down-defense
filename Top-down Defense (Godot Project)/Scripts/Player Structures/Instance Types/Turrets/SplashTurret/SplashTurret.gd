extends Turret

class_name SplashTurret

# warning-ignore:unused_argument
func fire(target_: Node2D):
	var targets = MapRefs.map.enemies_within_range(self, attacker_part._attack_range)
	print("targets: %s" % (targets as String))
