extends Navigation2D

class_name Pathfinder

onready var poly2D = get_node("../NavigationPolygonVisualizer") as Polygon2D
onready var circle_colliders = get_node("../Circle Colliders")

func _ready():	
	var circles = PoolVector3Array()
	for col in circle_colliders.get_children():
		var r = col.shape.radius
		var pos = col.global_position
		circles.append(Vector3(pos.x, pos.y, r))
	
	var islands = makeIslandPolies(circles, 15) # Array of island polygons.
	var polies = incorporate_polies(poly2D.polygon, islands)
	navpoly_set_polies(polies)
	
	poly2D.queue_free()

func _input(event):
	if event.is_action_pressed("LeftMouse"):
		$Node2D2.global_position = get_global_mouse_position()
		$Line2D.points = get_simple_path($Node2D.global_position, $Node2D2.global_position)


func incorporate_polies(base_nav_poly, polies) -> Array:
	var base = base_nav_poly
	var contained_polies = []
	for p in polies:
		var res = Geometry.clip_polygons_2d(base, p)
		if res.size() == 1:
			base = res[0]
		if res.size() == 2:
			if Geometry.is_polygon_clockwise(res[0]):
				base = res[1]
				contained_polies.append(res[0])
			else:
				base = res[0]
				contained_polies.append(res[1])
	contained_polies.append(base)
	return contained_polies

func navpoly_set_polies(polies: Array):
	var polygon = NavigationPolygon.new()
	for p in polies:
		polygon.add_outline(global_transform.xform(p))
	polygon.make_polygons_from_outlines()
	$NavigationPolygonInstance.navpoly = polygon

func makeIslandPolies(circles: PoolVector3Array, inflate_distance: float = 0) -> Array:
	# Inflates all circles and merges overlapping ones.
	var islands = [] # Array of PV3Arrays with elemnts of type (x_pos, y_pos, radius)

	for c in circles:
		var belong_to = [] # record which islands element belongs to by saving island index
		for i in islands.size():
			for c2 in islands[i]:
				if Vector2(c.x, c.y).distance_to(Vector2(c2.x, c2.y)) - c.z - c2.z -2.0*inflate_distance < 0:
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
		islandPolies.append(makeCirclePolygon(ci.z + inflate_distance, Vector2(ci.x, ci.y)))
		var doneAppended = []
		var lastAppended = [ci]
		while !lastAppended.empty():
			var la = []
			for c in lastAppended:
				for c2 in islands[i]:
					if c2 != c && !doneAppended.has(c2):
						if Vector2(c.x, c.y).distance_to(Vector2(c2.x, c2.y)) - c.z - c2.z -2.0*inflate_distance < 0:
							islandPolies[i] = mergeCircleToPoly(islandPolies[i], c2 + Vector3(0,0,inflate_distance))
							la.append(c2)
							doneAppended.append(c2)
			lastAppended = la
	
	return islandPolies

func mergeCircleToPoly(p: PoolVector2Array, c: Vector3) -> PoolVector2Array:
	var c_poly = makeCirclePolygon(c.z, Vector2(c.x, c.y))
	return Geometry.merge_polygons_2d(p, c_poly)[0] as PoolVector2Array

func makeCirclePolygon(radius: float, pos: Vector2 = Vector2.ZERO, vertices: float = 16) -> PoolVector2Array:
	var arm = Vector2.RIGHT * radius
	var points = PoolVector2Array()
	for i in vertices:
		points.append(arm.rotated(i * 2.0 * PI / vertices) + pos)
	return points
