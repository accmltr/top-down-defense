extends Node2D

class_name Pathfinder

onready var poly2D = get_node("../NavigationPolygonVisualizer") as Polygon2D
onready var circle_colliders = get_node("../Circle Colliders")

func _ready():
	var cols = circle_colliders.get_children()
	var p = makeCirclePolygon(cols[0].shape.radius)
	var p_transformed = cols[0].global_transform.xform(p)
	
	poly2D.polygon = Geometry.clip_polygons_2d(poly2D.polygon, p_transformed)[0]



func organizeIntoIslands(merge_distance: float = 40):
	# Takes the circle shapes from turrets/walls and organizes them into groups that should get merged together with filled spaces.
	var mdSqrd = pow(merge_distance, 2)
	var islands = [] # Array of PoolVector3Arrays with elemnts of type (x_pos, y_pos, radius)

	for col in circle_colliders.get_children():
		var r = col.shape.radius
		var pos = col.global_position
		var element = Vector3(pos.x, pos.y, r)

		var belong_to = [] # record which islands element belongs to by saving island index
		for i in islands.size():
			for circle in i:
				if pos.distance_squared_to(Vector2(circle.x, circle.y)) - (r+circle.y) < mdSqrd:
					belong_to.append(i)
					break
		if belong_to.size() == 0:
			islands.append(PoolVector3Array([element]))
		else:
			# Add element to first island index in "belong_to":
			islands[belong_to[0]].append(element)
			# Merge all islands in "belong_to" in "islands" into one island, and modify "islands" accordingly:
			






func makeCirclePolygon(radius: float, vertices: float = 16) -> PoolVector2Array:
	var arm = Vector2.RIGHT * radius
	var points = PoolVector2Array()
	
	for i in vertices:
		points.append(arm.rotated(i * 2.0 * PI / vertices))
	
	return points
