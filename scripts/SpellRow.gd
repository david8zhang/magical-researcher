class_name SpellRow
extends HBoxContainer

@onready var spell_name_label = $SpellName as Label
@onready var unlock_progress = $ProgressBar as ProgressBar
@onready var map_button = $Button as Button

func on_add_to_book(spell: DamageSpell):
	spell_name_label.text = spell.spell_name
	unlock_progress.value = 0
	unlock_progress.max_value = spell.unlock_cost

func unlock():
	print("Went here!")
	unlock_progress.hide()
	map_button.show()
