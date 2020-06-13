extends KinematicBody2D

var agent : SObstacle

func _ready():
	agent = SManager.create_obstacle(self, 18)
	
func _process(delta):
	update()
	
func _draw():

	draw_circle(Vector2(0,0), agent.collision_radius, Color(0.2,0.9,0.9,0.6))
