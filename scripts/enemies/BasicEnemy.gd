class_name BasicEnemy
extends Enemy

@onready var health_bar = $ProgressBar

func _ready():
	vision_radius = 200
	active_spell = SpellManager.instance.basic_spell.instantiate() as BasicSpell
	active_spell.caster = self
	add_child(active_spell)
	
func on_death():
	var player = game.player as Player
	player.gain_exp(exp_reward)