extends AttackExecution

class_name PerimeterSplashAttackExecution

# warning-ignore:unused_argument
func attack(target_: Node2D):
	var targets = MapRefs.map.enemies_within_range(_agent, _attacker_part._attack_range)
	for t in targets:
		t.get_health().change_health(self, -_agent.damage)
