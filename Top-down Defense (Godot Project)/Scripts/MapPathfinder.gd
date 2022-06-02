extends Navigation2D

class_name MapPathfinder

onready var navpoly_instance = $NavigationPolygonInstance

export var base_poly: PoolVector2Array
export var inflate_distance: float = 10

export var test_mode: bool = false

# Testing:
func _ready():
	if test_mode:
		$Line2D.visible = true
		$Node2D.visible = true
		$Node2D2.visible = true

# Testing:
func _input(event):
	if test_mode:
		if event.is_action_pressed("LeftMouse"):
			$Node2D2.global_position = get_global_mouse_position()
			$Line2D.points = get_simple_path($Node2D.global_position, $Node2D2.global_position)

func path_to_base(from: Vector2) -> PoolVector2Array:
	return get_simple_path(from, MapRefs.base().global_position)

func generate_navpoly(circles: PoolVector3Array):
	var islands = _generate_islands(circles, inflate_distance)
	var polies = _incorporate_polies(Geometry.offset_polygon_2d(base_poly, -inflate_distance)[0], islands)
	_set_nav_polies(polies)

func _incorporate_polies(_base_poly: PoolVector2Array, polies: Array) -> Array:
	var base = _base_poly
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

func _set_nav_polies(polies: Array):
	var polygon = NavigationPolygon.new()
	for p in polies:
		polygon.add_outline(global_transform.xform(p))
	polygon.make_polygons_from_outlines()
	navpoly_instance.navpoly = polygon

# Make island polygons from circles:
func _generate_islands(_circles: PoolVector3Array, _inflate_distance: float = 0) -> Array:
	# Inflates all circles and merges overlapping ones.
	var islands = [] # Array of PV3Arrays with elemnts of type (x_pos, y_pos, radius)

	for c in _circles:
		var belong_to = [] # record which islands element belongs to by saving island index
		for i in islands.size():
			for c2 in islands[i]:
				if Vector2(c.x, c.y).distance_to(Vector2(c2.x, c2.y)) - c.z - c2.z -2.0*_inflate_distance < 0:
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
		islandPolies.append(Acc_Geometry.create_circle_polygon(ci.z + _inflate_distance, Vector2(ci.x, ci.y)))
		var doneAppended = []
		var lastAppended = [ci]
		while !lastAppended.empty():
			var la = []
			for c in lastAppended:
				for c2 in islands[i]:
					if c2 != c && !doneAppended.has(c2):
						if Vector2(c.x, c.y).distance_to(Vector2(c2.x, c2.y)) - c.z - c2.z -2.0*_inflate_distance < 0:
							islandPolies[i] = _merge_circle_to_poly(islandPolies[i], c2 + Vector3(0,0,_inflate_distance))
							la.append(c2)
							doneAppended.append(c2)
			lastAppended = la
	
	return islandPolies

func _merge_circle_to_poly(p: PoolVector2Array, c: Vector3) -> PoolVector2Array:
	var c_poly = Acc_Geometry.create_circle_polygon(c.z, Vector2(c.x, c.y))
	return Geometry.merge_polygons_2d(p, c_poly)[0] as PoolVector2Array
