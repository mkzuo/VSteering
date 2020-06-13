extends SEntity
class_name SAgent

var _seek_objective := Vector2(0,0)

var _steering := Vector2(0,0)

var _avoid_force := Vector2(0,0)

var _min_distance_to_move := 2

var _handle_move := false

var mass := 2.0

var max_speed := 250.0

var avoid_radius : int

var velocity := Vector2(0,0)

var is_moving := false

func _init(owner_body : KinematicBody2D, collision_radius : int, avoid_radius : int, max_speed : float = 250, mass : float = 2.0):
	self._owner_body = owner_body
	self.collision_radius = collision_radius
	self.avoid_radius = avoid_radius
	self.max_speed = max_speed
	self.mass = mass

func fixed(fixed : bool):
	self.is_fixed = fixed

func seek(objective : Vector2):
	_seek_objective = objective
	handle_move(true)

func handle_move(handle : bool):
	_handle_move = handle

func get_look_dir() -> Vector2:
	return velocity.normalized()

func _move_and_slide(velocity : Vector2) -> Vector2:
	return _owner_body.move_and_slide( virtual_to_real_vector(velocity) )

func _get_seek_dir() -> Vector2:
	
	var dir_vec := _seek_objective - _owner_body.global_position
	
	if abs(dir_vec.x) < _min_distance_to_move and abs(dir_vec.y) < _min_distance_to_move:
		return Vector2(0,0)
	
	return (dir_vec.normalized())
