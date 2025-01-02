class_name WalkToRandomPoint
extends ActionLeaf

var random_destination

func tick(actor: Node, _blackboard: Blackboard):
	var enemy = actor as Enemy
	if random_destination == null:
		random_destination = _get_random_destination(enemy)
	var dist_to_dest = enemy.global_position.distance_to(random_destination)
	if dist_to_dest > 5:
		enemy.move_to_position(random_destination)
		return RUNNING
	else:
		random_destination = null
		return SUCCESS

func _get_random_destination(enemy):
	var x_diff = randi_range(-100, 100)
	var y_diff = randi_range(-100, 100)
	return Vector2(enemy.global_position.x + x_diff, enemy.global_position.y + y_diff)
