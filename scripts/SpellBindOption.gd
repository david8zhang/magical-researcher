class_name SpellBindOption
extends Button

enum MouseButtons {
	LMB,
	RMB
}

@onready var spell_label: Label = $SpellLabel
@onready var spell_icon: TextureRect = $SpellIcon

var spell_bind_menu: SpellBindMenu
var button_to_bind: MouseButtons
var spell_ref

func bind_spell(spell_to_bind: DamageSpell):
	spell_ref = spell_bind_menu.spell_to_bind
	spell_label.text = spell_to_bind.get_readable_name()
	spell_icon.texture = load(spell_to_bind.spell_icon_path)

func unbind_spell():
	spell_label.text = "None"
	spell_icon.texture = load("res://assets/panel.png")
	spell_ref = null
