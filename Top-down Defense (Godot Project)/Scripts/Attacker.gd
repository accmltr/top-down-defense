extends Node2D

export var _cast_time: float = 0.2
export var _attack_speed: float = 0.6
export var _attack_range: float = 200

var _reload_time: float = (1.0/_attack_speed) - _cast_time
var _is_reloading: bool = false
var _is_attacking: bool = false

func _physics_process(_delta):
	if _can_attack():
		_attack(_get_target())

func _finished_casting():
	_is_attacking = false
	_is_reloading = true
	yield(get_tree().create_timer(_reload_time), "timeout")
	_finished_reloading()

func _finished_reloading():
	_is_reloading = false

func _attack(target: Node):
	var t_name = target.to_string()
	target.queue_free()
	print("Target destroyed: %s" % t_name)
	_is_attacking = true
	yield(get_tree().create_timer(_cast_time), "timeout")
	_finished_casting()

func _can_attack() -> bool:
	if _is_attacking || _is_reloading:
		return false
	elif _get_target() == null:
		return false
	return true

func _get_target() -> Node:
	return MapRefs.map.closest_player_structure_within_range(global_position, _attack_range)
