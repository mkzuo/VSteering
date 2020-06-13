extends SEntity
class_name SObstacle

func _init(owner_body : KinematicBody2D, collision_radius : int):
	self._owner_body = owner_body
	self.collision_radius = collision_radius
