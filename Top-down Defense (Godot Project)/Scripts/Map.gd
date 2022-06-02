extends Node

class_name Map

onready var game_manager = $GameManager
onready var map_pathfinder = $MapPathfinder
onready var player_structs_manager = $PlayerStructures
onready var enemies_manager = $Enemies
onready var base = $PlayerStructures/Base
onready var wave_maker = $WaveMaker

func _ready():
	MapRefs.map = self
	player_structs_manager.setup()
	enemies_manager.setup()
	map_pathfinder.base_poly = $MapContent/NavPolyDrawn.polygon
	map_pathfinder.generate_navpoly(player_structs_manager.circles())
	game_manager.setup()

func closest_player_structure_within_range(enemy: Node2D, radius: float) -> Node2D:
	return _closest_node_within_range(player_structs_manager.player_structs, enemy, radius)

func closest_enemy_within_range(player_structure: Node2D, radius: float) -> Node2D:
	return _closest_node_within_range(enemies_manager.enemies, player_structure, radius)

func player_structures_within_range(enemy: Node2D, radius: float) -> Array:
	var res: Array = []
	for e in _nodes_within_range(player_structs_manager.player_structs, enemy, radius):
		res.append(e as PlayerStructure)
	return res

func enemies_within_range(player_structure: Node2D, radius: float) -> Array:
	var res: Array = []
	for e in _nodes_within_range(enemies_manager.enemies, player_structure, radius):
		res.append(e as Enemy)
	return res

func _closest_node_within_range(nodes: Array, agent: Node2D, radius: float) -> Node2D:
	var res: Node2D
	var cd: float
	for s in _nodes_within_range(nodes, agent, radius):
		var d = s.global_position.distance_to(agent.global_position) - s.radius - agent.radius
		if res == null:
			res = s
			cd = d
		elif d < cd:
			res = s
			cd = d
	return res

func _nodes_within_range(nodes: Array, agent: Node2D, radius: float) -> Array:
	var res: Array = []
	for n in nodes:
		if n != agent:
			var dist = agent.global_position.distance_to(n.global_position)
			if dist - n.radius - agent.radius < radius:
				res.append(n)
	return res
