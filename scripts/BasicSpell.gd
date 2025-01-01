class_name BasicSpell
extends DamageSpell

@export var projectile: PackedScene
var speed = 500

func cast(start_position: Vector2, target_position: Vector2):
	var new_projectile = projectile.instantiate() as RigidBody2D
	add_child(new_projectile)
	new_projectile.linear_velocity = (target_position - start_position).normalized() * speed
	new_projectile.global_position = Vector2(start_position.x, start_position.y)
