class_name CastDamageSpell
extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var enemy = actor as Enemy
	enemy.linear_velocity = Vector2.ZERO
	var player = enemy.game.player as Player
	if enemy.active_spell == null:
		return FAILURE
	enemy.active_spell.cast(enemy.global_position, player.global_position, Game.Side.Enemy)
	return SUCCESS
