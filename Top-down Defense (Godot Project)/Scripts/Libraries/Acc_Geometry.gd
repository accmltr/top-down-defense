extends Node

func create_circle_polygon(radius: float, pos: Vector2 = Vector2.ZERO, vertices: float = 16) -> PoolVector2Array:
	var arm = Vector2.RIGHT * radius
	var points = PoolVector2Array()
	for i in vertices:
		points.append(arm.rotated(i * 2.0 * PI / vertices) + pos)
	return points
