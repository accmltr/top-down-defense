extends Node2D

class_name Pathfinder

onready var poly2D = get_node("../NavigationPolygonVisualizer") as Polygon2D
onready var circle_colliders = get_node("../Circle Colliders")

func _ready():	
	var circles = PoolVector3Array()
	for col in circle_colliders.get_children():
		var r = col.shape.radius
		var pos = col.global_position
		circles.append(Vector3(pos.x, pos.y, r))
	
	var islands = makeIslandPolies(circles)
	
	while true:
		for i in islands:
			poly2D.polygon = i
			yield(get_tree().create_timer(1), "timeout")



func makeIslandPolies(circles: PoolVector3Array, merge_distance: float = 0) -> Array:
	# Takes the circle shapes from turrets/walls and organizes them into groups that should get merged together with filled spaces.
	var islands = [] # Array of PoolVector3Arrays with elemnts of type (x_pos, y_pos, radius)

	for c in circles:
		var belong_to = [] # record which islands element belongs to by saving island index
		for i in islands.size():
			for c2 in islands[i]:
				if Vector2(c.x, c.y).distance_to(Vector2(c2.x, c2.y)) - c.z - c2.z < merge_distance:
					belong_to.append(i)
					break
		
		# Merge or create islands as neccesary:
		if belong_to.size() == 0:
			islands.append(PoolVector3Array([c]))
		else:
			var t = islands[belong_to[0]] # temp variable to store PV3Array
			t.append(c)
			islands[belong_to[0]] = t
			var m = PoolVector3Array() # merged island
			for i in belong_to:
				for e in islands[i]:
					m.append(e)
			var new_islands = [m]
			for i in islands.size():
				if !belong_to.has(i):
					new_islands.append(islands[i])
			islands = new_islands
	
	# Go through every island and create its polygon:
	var islandPolies = []
	for i in islands.size():
		var ci = islands[i][0]
		islandPolies.append(makeCirclePolygon(ci.z, Vector2(ci.x, ci.y)))
		var doneAppended = []
		var lastAppended = [ci]
		while !lastAppended.empty():
			var la = []
			for c in lastAppended:
				for c2 in islands[i]:
					if c2 != c && !doneAppended.has(c2):
						if Vector2(c.x, c.y).distance_to(Vector2(c2.x, c2.y)) - c.z - c2.z < merge_distance:
							islandPolies[i] = mergeCircleToPoly(islandPolies[i], c2)
							la.append(c2)
							doneAppended.append(c2)
			lastAppended = la
	
	return islandPolies


# UNFINISHED: Needs to fill gap with rect.
func mergeCircleToPoly(p: PoolVector2Array, c: Vector3) -> PoolVector2Array:
	var cPoly = makeCirclePolygon(c.z, Vector2(c.x, c.y))
	
	# Make sure to merge rect to cPoly:
	
	return Geometry.merge_polygons_2d(p, cPoly)[0] as PoolVector2Array


func makeCirclePolygon(radius: float, pos: Vector2 = Vector2.ZERO, vertices: float = 16) -> PoolVector2Array:
	var arm = Vector2.RIGHT * radius
	var points = PoolVector2Array()
	
	for i in vertices:
		points.append(arm.rotated(i * 2.0 * PI / vertices) + pos)
	
	return points
