class_name SpellBindMenu
extends Control

@onready var spell_bind_option_1: SpellBindOption = $Panel/SpellBindOption
@onready var spell_bind_option_2: SpellBindOption = $Panel/SpellBindOption2
@onready var confirm_button: Button = $Panel/Confirm
@onready var game = get_node("/root/Main") as Game

var spell_to_bind: DamageSpell

func _ready():
	spell_bind_option_1.spell_bind_menu = self
	spell_bind_option_2.spell_bind_menu = self
	confirm_button.pressed.connect(confirm_spell_binding)

func confirm_spell_binding():
	hide()
