class_name SEntity

var _virtual_position : Vector2

var _owner_body : KinematicBody2D

var collision_radius : int

# Estos 2 metodos deben ser modificados para adaptar a un espacio isometrico
func update_virtual_position() -> void:
	_virtual_position = _owner_body.global_position

func virtual_to_real_vector(v : Vector2) -> Vector2:
	return v
