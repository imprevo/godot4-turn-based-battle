extends TileMap
class_name Grid

var cell_size = 16
var half_cell = Vector2(cell_size, cell_size) / 2

func is_available(point: Vector2):
	return get_cell_source_id(0, point) != -1

func get_path_points(from: Vector2, to: Vector2):
	# TODO: implement pathfinding
	var local_points = [from, to]
	return local_points.map(func(point): return point * cell_size + half_cell)

func snap_position_to_grid(point: Vector2):
	return (point / cell_size).floor() * cell_size
