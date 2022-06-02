extends Node2D

class_name WaveMaker

export var enemy_1: PackedScene
onready var spawnPoints = $SpawnPoints.get_children()
var wave: int = 1
var enemies_queued: float

func next_wave():
	# Starts next wave.
	var n = wave * 10 + 20
	for i in n:
		var p = spawnPoints[i%spawnPoints.size()-1]
		var e = enemy_1.instance()
		MapRefs.enemies_manager().add_enemy(e)
		e.global_position = p.global_position
		e.path = MapRefs.pathfinder().path_to_base(e.global_position)
		enemies_queued -= 1
		yield(get_tree().create_timer(1), "timeout")
	print("Wave Done")
