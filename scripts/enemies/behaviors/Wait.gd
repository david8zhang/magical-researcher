class_name Wait
extends ActionLeaf

var is_running = false
var wait_start_ts = -1
var wait_time = -1

func tick(actor: Node, _blackboard: Blackboard):
	if !is_running:
		is_running = true
		wait_start_ts = Time.get_unix_time_from_system() * 1000
		wait_time = randi_range(1, 3) * 1000
	var curr_ts = Time.get_unix_time_from_system() * 1000
	if (curr_ts - wait_start_ts) > wait_time:
		is_running = false
		return SUCCESS
	else:
		var enemy = actor as Enemy
		enemy.linear_velocity = Vector2.ZERO
		return RUNNING