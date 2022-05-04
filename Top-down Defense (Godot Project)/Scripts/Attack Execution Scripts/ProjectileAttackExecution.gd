extends AttackExecution

class_name ProjectileAttackExecution

export var _projectile: PackedScene
export var _fire_point_np: NodePath

onready var _fire_point: Node2D = get_node(_fire_point_np) as Node2D

func attack(target_: Node2D):
	var p = _projectile.instance() as Projectile
	_projectile_manager.add_projectile(p)
	p.global_position = _fire_point.global_position
	p.launch(_agent, _agent.damage, target_)
