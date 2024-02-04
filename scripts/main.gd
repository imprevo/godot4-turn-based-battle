extends Node2D

@onready var grid: Grid = $Grid
@onready var line: Line2D = $UnitPath
@onready var unit: Unit = $Unit

func _input(event):
	if event.is_action_pressed("ui_select"):
		var mouse_position = get_global_mouse_position()
		var target_cell_position = grid.local_to_map(mouse_position)
		if grid.is_available(target_cell_position):
			_move_unit(target_cell_position)

func _move_unit(path_to: Vector2):
	var path_from = grid.local_to_map(unit.position)
	var grid_points = grid.get_path_points(path_from, path_to)
	unit.follow_path(grid_points)
	line.points = grid_points
