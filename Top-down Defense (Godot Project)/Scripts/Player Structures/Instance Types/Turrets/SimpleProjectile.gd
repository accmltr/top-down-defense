extends Projectile

class_name SimpleProjectile

# A projectile used by enemies and turrets. Simply flies to target at a set speed, and applies damage on hit.

export var _speed: float = 70
var target_last_location: Vector2

signal hit(target)

func _physics_process(delta):
	if is_enemy_alive(_target):
		global_position = global_position.move_toward(_target.global_position, _speed*delta)
		target_last_location = _target.global_position
	else: 
		global_position = global_position.move_toward(target_last_location, _speed*delta)
	if _launched:
		if (target_last_location - global_position).length_squared() < 25:
			destroy()

func launch(agent_, damage_: float, target_: Node2D = null):
	.launch(agent_, damage_, target_)


func _on_body_entered(body):
	if body == _target:
		body.get_health().change_health(_agent, -_damage)
		emit_signal("hit", _target)
		destroy()
