extends Node2D

class_name Attacker

export var _is_enemy: bool = true
export var _cast_time: float = 0.2
export var _attack_speed: float = 0.6
export var _attack_range: float = 200

var _target: Node2D
onready var _reload_time: float = (1.0/_attack_speed) - _cast_time
var is_reloading: bool = false
var is_attacking: bool = false

signal cast_attack(target)
signal finished_casting(target)
signal finished_reloading()

func _physics_process(_delta):
	if _can_attack():
		_attack()

func _finished_casting():
	emit_signal("finished_casting", _target)
	is_attacking = false
	is_reloading = true
	yield(get_tree().create_timer(_reload_time), "timeout")
	_finished_reloading()

func _finished_reloading():
	emit_signal("finished_reloading")
	is_reloading = false

func _attack():
	emit_signal("cast_attack", _target)
	is_attacking = true
	yield(get_tree().create_timer(_cast_time), "timeout")
	_finished_casting()

func _can_attack() -> bool:
	if is_attacking || is_reloading:
		return false
	_target = _get_target()
	if _target == null:
		return false
	return true

func _get_target() -> Node2D:
	if _is_enemy:
		return MapRefs.map.closest_player_structure_within_range(self, _attack_range)
	else:
		return MapRefs.map.closest_enemy_within_range(self, _attack_range)
