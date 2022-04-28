extends Node2D

class_name Attacker

export var _is_enemy: bool = true
export var _cast_time: float = 0.2
export var _attack_speed: float = 0.6
export var _attack_range: float = 200

var _target: Node2D
var _reload_time: float = (1.0/_attack_speed) - _cast_time
var _is_reloading: bool = false
var _is_attacking: bool = false

func _physics_process(_delta):
	if _can_attack():
		_attack()

func _finished_casting():
	_is_attacking = false
	_is_reloading = true
	yield(get_tree().create_timer(_reload_time), "timeout")
	_finished_reloading()

func _finished_reloading():
	_is_reloading = false

func _attack():
	var t_name = _target.to_string()
	_target.queue_free()
	print("Target destroyed: %s" % t_name)
	_is_attacking = true
	yield(get_tree().create_timer(_cast_time), "timeout")
	_finished_casting()

func _can_attack() -> bool:
	if _is_attacking || _is_reloading:
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
