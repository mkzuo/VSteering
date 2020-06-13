extends KinematicBody2D

var agent : SAgent

func _ready():
	agent = SManager.create_agent(self, 16, 40)
	agent._seek_objective = global_position

func set_target(target : Vector2):
	agent.seek(target)

func _process(delta):
	update()
	
func _draw():	
	draw_circle(Vector2(0,0), agent.avoid_radius, Color(0.9,0.9,0.9,0.5))
	draw_line(Vector2(0,0), agent.velocity, Color(0.5,0.5,0.5), 3)
