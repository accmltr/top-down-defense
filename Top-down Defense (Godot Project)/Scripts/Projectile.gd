extends Node2D

class_name Projectile

var _manager
var _damage: float
var _target: Node2D
var _launched: bool = false

func launch(manager_, damage_: float, target_: Node2D):
	_manager = manager_
	_damage = damage_
	_target = target_
	_launched = true

func destroy():
	_manager.delete_projectile(self)
