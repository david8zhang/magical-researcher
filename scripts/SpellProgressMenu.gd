class_name SpellProgressMenu
extends Control

@export var spell_row_scene: PackedScene
@onready var spell_menu = $Panel/ScrollContainer/MarginContainer/VBoxContainer as VBoxContainer
var spell_rows_map = {}

func _ready():
	pass

func add_progress_to_spell(spell: DamageSpell):
	if !spell_rows_map.has(spell.spell_name):
		var new_spell_row = spell_row_scene.instantiate() as SpellRow
		new_spell_row.spell_ref = spell
		spell_menu.add_child(new_spell_row)
		new_spell_row.on_add_to_book(spell)
		spell_rows_map[spell.spell_name] = new_spell_row
	else:
		var spell_row = spell_rows_map[spell.spell_name]
		spell_row.unlock_progress += 1
		if spell_row.unlock_progress >= spell_row.max_value:
			spell_row.unlock()

func force_unlock_spell(spell_name: String):
	if spell_rows_map.has(spell_name):
		spell_rows_map[spell_name].unlock()
