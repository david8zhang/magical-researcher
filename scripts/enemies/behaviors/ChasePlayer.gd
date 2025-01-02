class_name ChasePlayer
extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var enemy = actor as Enemy
	var player = enemy.game.player as Player
	enemy.move_to_position(player.position)
	return SUCCESS