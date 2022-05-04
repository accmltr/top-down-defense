extends Node2D

class_name Enemy

onready var attacker_part: Attacker = $AttackerPart
onready var health: Health = $Health 

func _ready():
	# warning-ignore:return_value_discarded
	health.connect("die", self, "die")

func die(killer):
	print("%s: I got killed by %s" % [name, killer.name])
	MapRefs.map.delete_enemy(self)

func get_health() -> Health:
	return health
