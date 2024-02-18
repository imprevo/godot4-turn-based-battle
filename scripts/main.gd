extends Node2D

@onready var grid: Grid = $Grid
@onready var path_line: Line2D = $UnitPath
@onready var unit: Unit = $Unit
@onready var interactive_cells: InteractiveCells = $InteractiveCells
@onready var cursor: Cursor = $Cursor

var cells_in_range: Dictionary = {}
var is_animating = false

func _ready():
	cursor.visible = false
	_find_cells_in_range()
	_show_interactive_cells()

func _input(event):
	var cursor_tile_id = _get_cursor_tile()
	var focused_cell = _find_interactive_cell(cursor_tile_id)
	
	_update_cursor(focused_cell)

	if !is_animating:
		_update_path(focused_cell)

		if event.is_action_pressed("ui_select"):
			_move_unit(focused_cell)

func _update_path(cell: GridCell):
	if cell != null:
		path_line.visible = true
		path_line.points = cell.path
	else:
		path_line.visible = false		

func _update_cursor(cell: GridCell):
	if cell != null:
		var new_position = grid.snap_position_to_grid(cell.tile_id)
		cursor.move(new_position)
	else:
		cursor.hide()

func _move_unit(cell: GridCell):
	if cell != null:
		is_animating = true
		unit.follow_path(cell.path)

func _get_cursor_tile():
	var cursor_position = get_global_mouse_position()
	return grid.local_to_map(cursor_position)

func _find_interactive_cell(tile_id: Vector2i):
	return cells_in_range.get(tile_id)

func _find_cells_in_range():
	var unit_position = grid.local_to_map(unit.position)
	var max_distance = 5;
	cells_in_range.clear()
	var points = range(-max_distance, max_distance + 1)
	for x in points:
		for y in points:
			var tile_id = Vector2i(x + unit_position.x, y + unit_position.y)
			if grid.is_available(tile_id):
				var cost = abs(x) + abs(y)
				if cost <= max_distance:
					var path = grid.get_path_points(unit_position, tile_id)
					if path.size() <= max_distance:
						var grid_cell = GridCell.new(tile_id, cost, path)
						cells_in_range[tile_id] = grid_cell

func _show_interactive_cells():
	var cells: Array[GridCell] = []
	cells.assign(cells_in_range.values())
	interactive_cells.show_cells(cells)

func _on_unit_arrived():
	_find_cells_in_range()
	_show_interactive_cells()
	
	var cursor_tile_id = _get_cursor_tile()
	var focused_cell = _find_interactive_cell(cursor_tile_id)
	_update_path(focused_cell)
	_update_cursor(focused_cell)

	is_animating = false
