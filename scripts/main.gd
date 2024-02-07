extends Node2D

@onready var grid: Grid = $Grid
@onready var path_line: Line2D = $UnitPath
@onready var unit: Unit = $Unit
@onready var active_cell: ReferenceRect = $ActiveCell

var last_cursor_cell_id: Vector2i
var grid_path: Array
var is_animating = false

func _ready():
	active_cell.visible = false

func _input(event):
	var cursor_position = get_global_mouse_position()
	var cursor_cell_id = grid.local_to_map(cursor_position)
	var is_cell_available = grid.is_available(cursor_cell_id)
	var has_new_position = cursor_cell_id != last_cursor_cell_id
	
	if !is_animating:
		if has_new_position:
			_calculate_path(cursor_cell_id, is_cell_available)
			_update_path(is_cell_available)

		if is_cell_available && event.is_action_pressed("ui_select"):
			_move_unit()

	if has_new_position:
		_update_cursor(cursor_position, is_cell_available)
		last_cursor_cell_id = cursor_cell_id

func _calculate_path(cell_id: Vector2i, is_cell_available: bool):
	if is_cell_available:
		var unit_position = grid.local_to_map(unit.position)
		grid_path = grid.get_path_points(unit_position, cell_id)

func _update_path(is_cell_available: bool):
	path_line.visible = is_cell_available
	path_line.points = grid_path

func _update_cursor(cursor_position: Vector2, is_available: bool):
	active_cell.visible = is_available
	active_cell.position = grid.snap_position_to_grid(cursor_position)

func _move_unit():
	is_animating = true
	unit.follow_path(grid_path)

func _on_unit_arrived():
	var is_cell_available = grid.is_available(last_cursor_cell_id)
	_calculate_path(last_cursor_cell_id, is_cell_available)
	_update_path(is_cell_available)
	is_animating = false
