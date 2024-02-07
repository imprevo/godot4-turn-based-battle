extends TileMap
class_name Grid

var astar_grid = AStarGrid2D.new()
var main_layer = 0

func _ready():
	_init_grid()
	_init_cells()

func is_available(point: Vector2i):
	var tile_data = get_cell_tile_data(main_layer, point)
	return tile_data != null

func get_path_points(from: Vector2i, to: Vector2i):
	var local_path = astar_grid.get_id_path(from, to)
	var half_cell = tile_set.tile_size / 2
	return local_path.map(func(point): return point * rendering_quadrant_size + half_cell)

func snap_position_to_grid(point: Vector2):
	return (point / rendering_quadrant_size).floor() * rendering_quadrant_size

func _init_grid():
	astar_grid.region = get_used_rect()
	astar_grid.cell_size = tile_set.tile_size
	astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_CHEBYSHEV
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar_grid.update()
 
func _init_cells():
	for x in astar_grid.region.size.x:
		for y in astar_grid.region.size.y:
			var tile_position = Vector2i(x, y) + astar_grid.region.position
			var tile_data = get_cell_tile_data(main_layer, tile_position)
			if tile_data == null || !tile_data.get_custom_data("walkable") == false:
				astar_grid.set_point_solid(tile_position)
