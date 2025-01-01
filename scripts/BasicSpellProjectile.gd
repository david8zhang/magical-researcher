class_name BasicSpellProjectile
extends Node2D

var spell_ref: BasicSpell
@onready var detector = $Detector as Area2D

func _ready():
	detector.body_entered.connect(on_proj_hit)

func on_proj_hit(body: Node):
	self.queue_free()
	spell_ref.on_projectile_hit(body)