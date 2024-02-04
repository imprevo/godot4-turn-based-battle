extends CharacterBody2D
class_name Unit

enum State {
	Idle,
	Move,
}

var speed = 100
var path_index = 0
var path: PackedVector2Array
var state = State.Idle

func _physics_process(delta):
	match state:
		State.Idle:
			pass
		State.Move:
			_move()

func _move():
	if path_index > path.size() - 1:
		state = State.Idle
		return
	
	var target = path[path_index]
	velocity = position.direction_to(target) * speed
	move_and_slide()
	
	if position.distance_to(target) < 1:
		path_index = path_index + 1

func follow_path(points: PackedVector2Array):
	path = points
	path_index = 0
	state = State.Move
