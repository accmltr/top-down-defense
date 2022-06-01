extends Node

class_name PlayerStructsMan

var player_structs: Array = []

func setup():
	for c in get_children():
		player_structs.append(c)

func add_player_struct(s: PlayerStructure):
	player_structs.append(s)
	if s.get_parent():
		s.get_parent().remove_child(s)
	add_child(s)

func delete_player_struct(s: PlayerStructure):
	player_structs.erase(s)
	s.queue_free()

func circles() -> PoolVector3Array:
	var res = PoolVector3Array()
	for s in player_structs:
		res.append(Vector3(s.global_position.x, s.global_position.y, s.radius))
	return res
