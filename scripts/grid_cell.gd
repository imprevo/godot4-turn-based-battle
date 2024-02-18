class_name GridCell

var tile_id: Vector2i
var cost: int
var path: Array[Vector2]

func _init(_tile_id: Vector2i, _cost: int, _path: Array[Vector2]):
	tile_id = _tile_id
	cost = _cost
	path = _path
