class_name SpellPoint
extends RigidBody2D

var spell_ref: DamageSpell
@onready var detector = $Detector as Area2D

func _ready():
	detector.body_entered.connect(on_body_entered)

func on_body_entered(body: Node):
	queue_free()
	var player = body as Player
	player.spell_progress_menu.add_progress_to_spell(spell_ref)
