class_name BasicSpell2
extends DamageSpell

@export var projectile: PackedScene
var projectile_speed = 250
var spell_power = 5
var did_cast = false
var directions = [
	Vector2(0, 1),
	Vector2(1, 0),
	Vector2(-1, 0),
	Vector2(0, -1)
]

func _ready():
	spell_name = "BASIC_SPELL_2"
	spell_range = 150
	cooldown_seconds = 1.0
	spell_icon_path = "res://icon.svg"

func cast(start_position: Vector2, _target_position: Vector2, side: Game.Side):
	if !did_cast:
		did_cast = true
		var projectiles = []
		for dir in directions:
			var new_projectile = projectile.instantiate() as BasicSpellProjectile
			new_projectile.spell_ref = self
			game.add_child(new_projectile)
			new_projectile.detector.set_collision_layer_value(3, true)
			if side == Game.Side.Player:
				new_projectile.detector.set_collision_mask_value(2, true)
			elif side == Game.Side.Enemy:
				new_projectile.detector.set_collision_mask_value(1, true)
			new_projectile.global_position = Vector2(start_position.x, start_position.y)
			new_projectile.linear_velocity = dir * projectile_speed
			projectiles.append(new_projectile)


		# Expire projectiles
		var proj_remove_timer = Timer.new()
		proj_remove_timer.wait_time = 5
		proj_remove_timer.one_shot = true
		proj_remove_timer.autostart = true
		var on_proj_remove_timeout = Callable(self, "remove_projectile").bind(projectiles, proj_remove_timer)
		proj_remove_timer.timeout.connect(on_proj_remove_timeout)
		add_child(proj_remove_timer)

		# Handle spell cooldown
		var cooldown_timer = Timer.new()
		cooldown_timer.wait_time = cooldown_seconds
		cooldown_timer.one_shot = true
		cooldown_timer.autostart = true
		var on_cooldown_timeout = Callable(self, "cooldown_expire").bind(cooldown_timer)
		cooldown_timer.timeout.connect(on_cooldown_timeout)
		add_child(cooldown_timer)

func cooldown_expire(timer: Timer):
	timer.queue_free()
	did_cast = false

func remove_projectile(projectiles: Array[BasicSpellProjectile], timer: Timer):
	timer.queue_free()
	for p in projectiles:
		p.queue_free()

func on_projectile_hit(body: Node):
	if body is BasicEnemy:
		var enemy = body as Enemy
		var player = game.player
		var damage = spell_power * (player.attack / enemy.attack)
		enemy.take_damage(damage)
	elif body is Player:
		var player = body as Player
		var enemy_caster = caster as Enemy
		var damage = spell_power * (enemy_caster.attack / player.defense)
		player.take_damage(damage)