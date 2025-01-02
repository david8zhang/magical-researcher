class_name BasicEnemy
extends Enemy

@onready var health_bar = $ProgressBar

func _ready():
	vision_radius = 200
	active_spell = SpellManager.instance.basic_spell.instantiate() as BasicSpell
	add_child(active_spell)