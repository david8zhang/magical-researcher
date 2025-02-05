class_name IsAggro
extends ConditionLeaf

func tick(_actor: Node, blackboard: Blackboard):
	var is_aggro = blackboard.get_value("is_aggro")
	return SUCCESS if is_aggro else FAILURE