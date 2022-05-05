extends Node

class_name AttackExecution

export var run_without_animator = false

var _agent
var _attacker_part
var _projectile_manager

func setup(agent_):
	_agent = agent_
	_attacker_part = _agent.attacker_part
	_projectile_manager = _agent.projectile_manager
	
	if run_without_animator:
		_attacker_part.connect("cast_attack", self, "attack")

func attack(target_):
	print("%s: attack %s with %s damage"%[_agent.name, target_, _agent.damage])
