class_name IsPlayerWithinVisionRange
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var enemy = actor as Enemy
	var player = enemy.game.player as Player
	var dist_to_player = enemy.global_position.distance_to(player.global_position)
	return SUCCESS if dist_to_player <= enemy.vision_radius else FAILURE