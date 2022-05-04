extends Turret

class_name SplashTurret

# warning-ignore:unused_argument
func fire(target_: Node2D):
	var targets = MapRefs.map.enemies_within_range(self, attacker_part._attack_range)
	for t in targets:
		t.get_health().change_health(self, -damage)
