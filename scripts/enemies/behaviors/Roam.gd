class_name Roam
extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var enemy = actor as Enemy
	enemy.roam_around()
	return SUCCESS