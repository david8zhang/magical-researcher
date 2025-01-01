class_name BasicSpell
extends DamageSpell

@export var projectile: PackedScene
var speed = 500

func cast(start_position: Vector2, target_position: Vector2, side: Game.Side):
	var new_projectile = projectile.instantiate() as BasicSpellProjectile
	new_projectile.spell_ref = self
	add_child(new_projectile)
	if side == Game.Side.Player:
		new_projectile.detector.set_collision_mask_value(2, true)
		new_projectile.detector.set_collision_layer_value(3, true)

	new_projectile.linear_velocity = (target_position - start_position).normalized() * speed
	new_projectile.global_position = Vector2(start_position.x, start_position.y)

func on_projectile_hit(body: Node):
	if body is BasicEnemy:
		print("hit enemy!")
