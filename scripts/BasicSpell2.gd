class_name BasicSpell2
extends DamageSpell

@export var projectile: PackedScene
var projectile_speed = 250
var spell_power = 5
var did_cast = false

func _ready():
	spell_name = "Basic Spell 2"
	spell_range = 150
	cooldown_seconds = 1.0

func cast(start_position: Vector2, target_position: Vector2, side: Game.Side):
	pass