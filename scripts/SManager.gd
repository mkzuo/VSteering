extends Node

var registered_agents := []
var registered_obstacles := []

var AGENT_AVOID_MAX_FORCE := 400.0
var OBSTACLE_AVOID_MAX_FORCE := 200.0

var DISTANCE_TO_SLOW := 20.0

var USE_CUSTOM_VIRTUAL_VECTOR_TRANSFORM := true

func create_agent(owner_body : KinematicBody2D, collision_radius : int, avoid_radius : int) -> SAgent:
	var agent = SAgent.new(owner_body, collision_radius, avoid_radius)
	register_agent(agent)
	return agent
	
func create_obstacle(owner_body : KinematicBody2D, collision_radius : int) -> SObstacle:
	var agent = SObstacle.new(owner_body, collision_radius)
	register_obstacle(agent)
	return agent

func register_agent(agent : SAgent) -> void:
	registered_agents.append(agent)

func unregister_agent(agent : SAgent) -> void:
	registered_agents.erase(agent)

func register_obstacle(agent : SObstacle) -> void:
	registered_obstacles.append(agent)

func unregister_obstacle(agent : SObstacle) -> void:
	registered_obstacles.erase(agent)

func _physics_process(delta):
	_update_virtual_positions()
	_calculate_agents_steering(delta)

func _update_virtual_positions():
	for agent in registered_agents:
		agent.update_virtual_position()
		
	for obstacle in registered_obstacles:
		obstacle.update_virtual_position()

func _calculate_agents_steering(delta):

	for agent in registered_agents :
		agent = agent as SAgent
		
		agent._steering = Vector2(0,0)
		
		agent._avoid_force = Vector2(0,0)
	
		var distance : float = agent._virtual_position.distance_to(agent._seek_objective)
			
		var desired_velocity : Vector2 = (agent._seek_objective - agent._virtual_position).normalized()*agent.max_speed
		
		if distance < DISTANCE_TO_SLOW:
			desired_velocity *= (distance/DISTANCE_TO_SLOW) * 0.75 
		
		agent._steering = (desired_velocity - agent.velocity)/agent.mass
		
		_calcule_agent_avoid_agents(agent, delta)
		_calcule_agent_avoid_obstacles(agent, delta)
		
		agent._steering += agent._avoid_force
		
		if agent._steering.length_squared() < agent._min_distance_to_move*agent._min_distance_to_move:
			agent._steering *= 0.8
			
	for agent in registered_agents:
		
		agent.velocity += agent._steering/agent.mass
	
		agent.velocity.clamped(agent.max_speed)
		
		agent.velocity = agent._move_and_slide(agent.velocity)

func _calcule_agent_avoid_agents(agent : SAgent, delta : float):
	for compared_agent in registered_agents:
		
		if compared_agent == agent:
			continue
	
		var distance_vec : Vector2 = compared_agent._virtual_position - agent._virtual_position
		var sum_avoid_collision : float = agent.avoid_radius + compared_agent.collision_radius
		
		if distance_vec.length_squared() < sum_avoid_collision*sum_avoid_collision:
			agent._avoid_force += distance_vec.normalized()*(sum_avoid_collision-distance_vec.length())/(sum_avoid_collision)*-AGENT_AVOID_MAX_FORCE
		
func _calcule_agent_avoid_obstacles(agent : SAgent, delta : float):
	for compared_obstacle in registered_obstacles:
		
		var distance_vec : Vector2 = compared_obstacle._virtual_position - agent._virtual_position
		var sum_avoid_collision : float = agent.avoid_radius + compared_obstacle.collision_radius
		
		if distance_vec.length_squared() < sum_avoid_collision*sum_avoid_collision:
			agent._avoid_force += distance_vec.normalized()*(sum_avoid_collision-distance_vec.length())/(sum_avoid_collision)*-OBSTACLE_AVOID_MAX_FORCE

