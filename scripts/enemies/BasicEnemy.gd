class_name BasicEnemy
extends Enemy

@export var spell_point_scene: PackedScene
@onready var sprite = $Sprite2D as Sprite2D
@onready var health_bar = $ProgressBar

func _ready():
	vision_radius = 200
	active_spell = SpellManager.instance.create_spell("BASIC_SPELL_2")
	active_spell.caster = self
	add_child(active_spell)
	
func on_death():
	var player = game.player as Player
	player.gain_exp(exp_reward)

	# Drop a spell point
	var spell_point = spell_point_scene.instantiate() as SpellPoint
	active_spell.reparent(spell_point)
	spell_point.spell_ref = active_spell
	add_sibling(spell_point)
	spell_point.global_position = Vector2(global_position.x, global_position.y)
