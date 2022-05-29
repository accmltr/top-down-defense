extends Node2D

class_name Pathfinder

onready var poly2D = get_node("../NavigationPolygonVisualizer") as Polygon2D
onready var circle_colliders = get_node("../Circle Colliders")

func _ready():
	var cols = circle_colliders.get_children()
	var p = makeCirclePolygon(cols[0].shape.radius)
	var p_transformed = cols[0].global_transform.xform(p)
	
	poly2D.polygon = Geometry.clip_polygons_2d(poly2D.polygon, p_transformed)[0]



func organizeIntoIslands(merge_distance: float = 0):
	# Takes the circle shapes from turrets/walls and organizes them into groups that should get merged together with filled spaces.
	var islands = [] # Array of PoolVector3Arrays with elemnts of type (x_pos, y_pos, radius)

	for col in circle_colliders.get_children():
		var r = col.shape.radius
		var pos = col.global_position
		var element = Vector3(pos.x, pos.y, r)

		var belong_to = [] # record which islands element belongs to by saving island index
		for i in islands.size():
			for circle in i:
				if pos.distance_to(Vector2(circle.x, circle.y)) - (r+circle.y) < merge_distance:
					belong_to.append(i)
					break
		
		# Merge or create islands as neccesary:
		if belong_to.size() == 0:
			islands.append(PoolVector3Array([element]))
		else:
			islands[belong_to[0]].append(element)
			
			var m = PoolVector3Array() # merged island
			
			for i in belong_to:
				for e in islands[i]:
					m.append(e)
			
			var new_islands = [m]
			
			for i in islands.size():
				if !belong_to.has(i):
					new_islands.append(islands[i])
			
			islands = new_islands
		
		# Go through every island and create them:

# UNFINISHED:
func mergeCircles(merge_distance: float, c1: Vector3, c2: Vector3) -> PoolVector2Array:
	var p1 = shiftPolygon(makeCirclePolygon(c1.y), Vector2(c1.x, c1.y))
	var p2 = shiftPolygon(makeCirclePolygon(c2.y), Vector2(c2.x, c2.y))
	
	return Geometry.merge_polygons_2d(p1, p2)[0] as PoolVector2Array

func shiftPolygon(poly: PoolVector2Array, offset: Vector2):
	var res = PoolVector2Array()
	for pt in poly:
		res.append(pt + offset)
	return res


func makeCirclePolygon(radius: float, vertices: float = 16) -> PoolVector2Array:
	var arm = Vector2.RIGHT * radius
	var points = PoolVector2Array()
	
	for i in vertices:
		points.append(arm.rotated(i * 2.0 * PI / vertices))
	
	return points
