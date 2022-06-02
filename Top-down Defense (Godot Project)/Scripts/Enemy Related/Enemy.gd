extends KinematicBody2D

class_name Enemy


onready var attacker_part: Attacker = $AttackerPart
onready var health: Health = $Health 
onready var radius: float = $CollisionShape2D.shape.radius

var path: PoolVector2Array setget set_path_val
var path_length: float
var nextInPath: int = 0
export var movespeed: float = 20
var l: Line2D # Visualize pathfinding

func _ready():
	# warning-ignore:return_value_discarded
	health.connect("die", self, "die")

func set_path_val(val):
	path = val
	path_length = path.size()
	
	# Testing code:
#	l = Line2D.new()
#	l.width *= .5
#	l.modulate.a = .5
#	MapRefs.map.add_child(l)
#	l.points = path

func _physics_process(_delta):
	if nextInPath < path_length:
		var des = path[nextInPath]
		var des_delta = des - global_position
		if des_delta.length() < 5:
			nextInPath += 1
			des_delta = des - global_position
		# warning-ignore:return_value_discarded
		move_and_slide(des_delta.normalized() * movespeed)

func die(killer):
	print("%s: I got killed by %s" % [name, killer.name])
#	l.free()
	MapRefs.map.enemies_manager.delete_enemy(self)

func get_health() -> Health:
	return health
