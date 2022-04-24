extends Node

class_name Map

onready var _player_structures_holder: Node = $PlayerStructures
onready var _enemies_holder: Node = $Enemies

func _ready():
	MapRefs.map = self

func closest_player_structure_within_range(pos: Vector2, radius: float) -> PlayerStructure:
	return _closest_node_within_range(_player_structures_holder, pos, radius) as PlayerStructure

func closest_enemy_within_range(pos: Vector2, radius: float) -> Enemy:
	return _closest_node_within_range(_enemies_holder, pos, radius) as Enemy

func player_structures_within_range(pos: Vector2, radius: float) -> Array:
	var res: Array = []
	for e in _nodes_within_range(_player_structures_holder, pos, radius):
		res.append(e as PlayerStructure)
	return res

func enemies_within_range(pos: Vector2, radius: float) -> Array:
	var res: Array = []
	for e in _nodes_within_range(_enemies_holder, pos, radius):
		res.append(e as Enemy)
	return res

func _closest_node_within_range(holder_node: Node, pos: Vector2, radius: float) -> Node:
	var res: Node
	var cd: float
	for s in _nodes_within_range(holder_node, pos, radius):
		var d = s.global_position.distance_squared_to(pos)
		if res == null:
			res = s
			cd = s.global_position.distance_squared_to(pos)
		elif d < cd:
			res = s
			cd = d
	return res

func _nodes_within_range(holder_node: Node, pos: Vector2, radius: float) -> Array:
	var r2 = pow(radius, 2)
	var res: Array = []
	for n in holder_node.get_children():
		if (pos - n.global_position).length() < radius:
			res.append(n)
	return res
