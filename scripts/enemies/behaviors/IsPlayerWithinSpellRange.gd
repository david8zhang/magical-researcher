class_name IsPlayerWithinSpellRange
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var enemy = actor as Enemy
	var player = enemy.game.player as Player
	var dist_to_player = enemy.global_position.distance_to(player.global_position)	
	var active_spell = enemy.active_spell as DamageSpell
	if active_spell == null:
		return FAILURE
	return SUCCESS if dist_to_player <= active_spell.spell_range else FAILURE