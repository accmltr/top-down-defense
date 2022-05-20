extends Node

class_name Map

onready var _player_structures_holder: Node = $PlayerStructures
onready var _enemies_holder: Node = $Enemies
onready var _base: Base = $PlayerStructures/Base
onready var _nav: Navigation2D = $MapContent/Navigation2D

var player_structs: Array = []
var enemies: Array = []

func _ready():
	MapRefs.map = self

func path_to_base(e: Enemy) -> PoolVector2Array:
	return _nav.get_simple_path(e.global_position, _base.global_position)

func add_enemy(e: Enemy):
	if e.get_parent():
		e.get_parent().remove_child(e)
	_enemies_holder.add_child(e)
	enemies.append(e)

func delete_enemy(e: Enemy):
	enemies.erase(e)
	e.queue_free()

func add_player_struct(s: PlayerStructure):
	player_structs.append(s)
	if s.get_parent():
		s.get_parent().remove_child(s)
	_player_structures_holder.add_child(s)

func delete_player_struct(s: PlayerStructure):
	player_structs.erase(s)
	s.queue_free()

func has_enemy(e: Enemy) -> bool:
	return enemies.has(e)

func closest_player_structure_within_range(enemy: Node2D, radius: float) -> Node2D:
	return _closest_node_within_range(_player_structures_holder, enemy, radius)

func closest_enemy_within_range(player_structure: Node2D, radius: float) -> Node2D:
	return _closest_node_within_range(_enemies_holder, player_structure, radius)

func player_structures_within_range(enemy: Node2D, radius: float) -> Array:
	var res: Array = []
	for e in _nodes_within_range(_player_structures_holder, enemy, radius):
		res.append(e as PlayerStructure)
	return res

func enemies_within_range(player_structure: Node2D, radius: float) -> Array:
	var res: Array = []
	for e in _nodes_within_range(_enemies_holder, player_structure, radius):
		res.append(e as Enemy)
	return res

func _closest_node_within_range(holder_node: Node, agent: Node2D, radius: float) -> Node2D:
	var res: Node2D
	var cd: float
	for s in _nodes_within_range(holder_node, agent, radius):
		var d = s.global_position.distance_squared_to(agent.global_position)
		if res == null:
			res = s
			cd = d
		elif d < cd:
			res = s
			cd = d
	return res

func _nodes_within_range(holder_node: Node, agent: Node2D, radius: float) -> Array:
	var r2 = pow(radius, 2)
	var res: Array = []
	for n in holder_node.get_children():
		if n != agent:
			if agent.global_position.distance_squared_to(n.global_position) < r2:
				res.append(n)
	return res
