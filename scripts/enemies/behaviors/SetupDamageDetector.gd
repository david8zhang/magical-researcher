class_name SetupDamageDetector
extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var enemy = actor as Enemy
	var callable = Callable(self, "set_aggro_flag").bind(blackboard)
	enemy.on_damage.connect(callable)

func set_aggro_flag(blackboard: Blackboard):
	blackboard.set_value("is_aggro", true)