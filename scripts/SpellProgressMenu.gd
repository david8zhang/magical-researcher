class_name SpellProgressMenu
extends Control

@export var spell_row_scene: PackedScene
@onready var game = get_node("/root/Main") as Game
@onready var spell_menu = $Panel/ScrollContainer/MarginContainer/VBoxContainer as VBoxContainer
var spell_rows_map = {}

func _ready():
	pass

func add_progress_to_spell(spell: DamageSpell):
	if !spell_rows_map.has(spell.spell_name):
		spell.reparent(self) # Reparent spell to current progress class (since spell reference gets freed once spell point is picked up)
		var new_spell_row = spell_row_scene.instantiate() as SpellRow
		spell_menu.add_child(new_spell_row)
		new_spell_row.on_add_to_book(spell)
		new_spell_row.unlock_progress.value += 1
		spell_rows_map[spell.spell_name] = new_spell_row
	else:
		var spell_row = spell_rows_map[spell.spell_name]
		if !spell_row.is_unlocked:
			spell_row.unlock_progress.value += 1
			if spell_row.unlock_progress.value >= spell_row.unlock_progress.max_value:
				spell_row.unlock()
				var spell_ref = spell_row.spell_ref
				game.create_new_spell_unlock_alert(spell_ref.get_readable_name())

func force_unlock_spell(spell_name: String):
	if spell_rows_map.has(spell_name):
		spell_rows_map[spell_name].unlock()
	else:
		var new_spell_row = spell_row_scene.instantiate() as SpellRow
		var new_spell = SpellManager.instance.create_spell(spell_name)
		add_child(new_spell)
		spell_menu.add_child(new_spell_row)
		new_spell_row.on_add_to_book(new_spell)
		spell_rows_map[spell_name] = new_spell_row
		new_spell_row.unlock()
