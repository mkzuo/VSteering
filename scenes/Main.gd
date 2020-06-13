extends Node

var Entity = preload("res://entities/Entity.tscn")
var Obstacle = preload("res://entities/Obstacle.tscn")

var entities_1 := []
var entities_2 := []

var obstacles := []

export var spawn_num_1 := 4
export var spawn_num_2 := 0

export var obstacles_num := 20

func _ready():
	
	randomize()
	
	for s in range(spawn_num_1):
		var e = Entity.instance()
		$Entities.add_child(e)
		entities_1.append(e)
		e.global_position = Vector2(randf()*600, randf()*400)
		e.agent.max_speed = 190
		e.agent.avoid_radius = 30
	
	for s in range(spawn_num_2):
		var e = Entity.instance()
		$Entities.add_child(e)
		entities_2.append(e)
		e.global_position = Vector2(randf()*600, randf()*300)
		e.get_node("Sprite").self_modulate = Color(0.6,0.6,0.2)
		e.agent.max_speed = 350

		
	for s in range(obstacles_num):
		var e = Obstacle.instance()
		$Entities.add_child(e)
		obstacles.append(e)
		e.global_position = Vector2(randi() % 20, randi() % 15)*32
		#e.set_target(e.global_position)
		e.get_node("Sprite").self_modulate = Color(0.2,0.6,0.6)
		#e.agent.max_speed = 100

func _input(event):
	if event is InputEventMouseButton:
		
		if event.button_index == 1:
			set_all_target_1(event.position*Vector2(1,1))
			print("left click")
		elif event.button_index == 2:
			set_all_target_2(event.position*Vector2(1,1))
			print("right click")

func set_all_target_1(m_position):
	for e in entities_1:
		e.set_target(m_position)

func set_all_target_2(m_position):
	for e in entities_2:
		e.set_target(m_position)
