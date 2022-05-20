extends Node2D

class_name Enemy

onready var attacker_part: Attacker = $AttackerPart
onready var health: Health = $Health 

var l: Line2D # Visualize pathfinding

func _ready():
	# warning-ignore:return_value_discarded
	health.connect("die", self, "die")
	
	# Testing code:
	yield(get_tree().create_timer(1), "timeout")
	l = Line2D.new()
	MapRefs.map.add_child(l)
	l.points = MapRefs.map.path_to_base(self)
	# :Testing code

func die(killer):
	print("%s: I got killed by %s" % [name, killer.name])
	l.free()
	MapRefs.map.delete_enemy(self)

func get_health() -> Health:
	return health
