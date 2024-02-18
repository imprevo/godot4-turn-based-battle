class_name InteractiveCells
extends Node2D

var valid_cell: PackedScene = preload("res://prefabs/interactive_cell.tscn")
var cell_size = 16

func show_cells(valid_cells: Array[GridCell]):
	_clear()

	for grid_cell in valid_cells:
		var cell = valid_cell.instantiate()
		add_child(cell)
		cell.position = grid_cell.tile_id * cell_size

func _clear():
	for child in get_children():
		remove_child(child)
