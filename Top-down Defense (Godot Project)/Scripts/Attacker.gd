extends Node2D

class_name Attacker

export var _is_enemy: bool = true
export var _cast_time: float = 0.2
export var _attack_speed: float = 0.6
export var _attack_range: float = 200

var target: Node2D
onready var _reload_time: float = (1.0/_attack_speed) - _cast_time
var is_reloading: bool = false
var is_attacking: bool = false
var cast_timer: Timer
var reload_timer: Timer

signal cast_attack(_target_)
signal finished_casting(_target_)
signal finished_reloading()

func _ready():
	cast_timer = Timer.new()
	cast_timer.process_mode = Timer.TIMER_PROCESS_PHYSICS
	cast_timer.one_shot = true
	# warning-ignore:return_value_discarded
	cast_timer.connect("timeout", self, "_finished_casting")
	add_child(cast_timer)
	reload_timer = Timer.new()
	reload_timer.process_mode = Timer.TIMER_PROCESS_PHYSICS
	reload_timer.one_shot = true
	# warning-ignore:return_value_discarded
	reload_timer.connect("timeout", self, "_finished_reloading")
	add_child(reload_timer)

func _physics_process(_delta):
	if _can_attack():
		_attack()

func _finished_casting():
	emit_signal("finished_casting", target)
	is_attacking = false
	is_reloading = true
	reload_timer.start(_reload_time)

func _finished_reloading():
	emit_signal("finished_reloading")
	is_reloading = false

func _attack():
	emit_signal("cast_attack", target)
	is_attacking = true
	cast_timer.start(_cast_time)

func _can_attack() -> bool:
	if is_attacking || is_reloading:
		return false
	target = _get_target()
	if target == null:
		return false
	return true

func _get_target() -> Node2D:
	if _is_enemy:
		return MapRefs.map.closest_player_structure_within_range(get_parent(), _attack_range)
	else:
		return MapRefs.map.closest_enemy_within_range(get_parent(), _attack_range)

#func _notification(what):
#	if what == NOTIFICATION_PREDELETE:
#		timer.free()
