class_name BasicSpell
extends DamageSpell

@export var projectile: PackedScene
var projectile_speed = 500
var did_cast = false

func _ready():
	spell_range = 150
	cooldown_seconds = 1.0

func cast(start_position: Vector2, target_position: Vector2, side: Game.Side):
	if !did_cast:
		did_cast = true
		var new_projectile = projectile.instantiate() as BasicSpellProjectile
		new_projectile.spell_ref = self
		game.add_child(new_projectile)
		new_projectile.detector.set_collision_layer_value(3, true)
		if side == Game.Side.Player:
			new_projectile.detector.set_collision_mask_value(2, true)
		elif side == Game.Side.Enemy:
			new_projectile.detector.set_collision_mask_value(1, true)
		new_projectile.global_position = Vector2(start_position.x, start_position.y)
		new_projectile.linear_velocity = (target_position - start_position).normalized() * projectile_speed

		# Handle spell cooldown
		var cooldown_timer = Timer.new()
		cooldown_timer.wait_time = cooldown_seconds
		cooldown_timer.one_shot = true
		cooldown_timer.autostart = true
		var callable = Callable(self, "cooldown_expire")
		cooldown_timer.timeout.connect(callable)
		add_child(cooldown_timer)

func cooldown_expire():
	did_cast = false

func on_projectile_hit(body: Node):
	if body is BasicEnemy:
		print("hit enemy!")
