extends Node2D

class_name Projectile

var _agent
var _manager
var _damage: float
var _target: Node2D
var _launched: bool = false

func launch(agent_, damage_: float, target_: Node2D = null):
	_agent = agent_
	_manager = _agent.projectile_manager
	_damage = damage_
	_target = target_
	_launched = true

func destroy():
	_manager.delete_projectile(self)

func get_manager():
	return _manager

func is_enemy_alive(enemy):
	return MapRefs.enemies_manager().enemies.has(enemy)
