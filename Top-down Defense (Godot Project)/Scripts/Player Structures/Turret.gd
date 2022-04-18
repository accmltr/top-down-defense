extends Node

class_name Turret

var _fire_rate: float = 1
var _bogies: Array = []
var _reloaded: bool = true

onready var _attack_range: Area2D = $AttackRange
onready var _reload_timer: Timer = $ReloadTimer

func _ready():
	_attack_range.connect("body_entered", self, "_on_enemy_enter")
	_attack_range.connect("body_exited", self, "_on_enemy_exit")
	_reload_timer.wait_time = 1.0/_fire_rate
	_reload_timer.connect("timeout", self, "_on_reloaded")

func _physics_process(delta):
	if _can_attack():
		_fire()

func _fire():
	_closest_bogy().queue_free()
	_reload_timer.start()
	_reloaded = false

func _can_attack() -> bool:
	return _reloaded && _bogies.size() > 0

func _on_enemy_enter(body: Node):
	_bogies.append(body)

func _on_enemy_exit(body: Node):
	_bogies.remove(_bogies.find(body))

func _on_reloaded():
	_reloaded = true

func _closest_bogy() -> Enemy:
	return _bogies[0]
