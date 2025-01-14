class_name SpellRow
extends HBoxContainer

@onready var spell_name_label = $SpellName as Label
@onready var unlock_progress = $ProgressBar as ProgressBar
@onready var map_button = $Button as Button
@onready var game = get_node("/root/Main") as Game

var spell_ref: DamageSpell

func _ready():
	map_button.pressed.connect(open_spell_bind_menu)

func open_spell_bind_menu():
	var player = game.player as Player
	player.spell_bind_menu.spell_to_bind = spell_ref
	player.spell_bind_menu.show()

func on_add_to_book(spell: DamageSpell):
	spell_ref = spell
	spell_name_label.text = spell.spell_name
	unlock_progress.value = 0
	unlock_progress.max_value = spell.unlock_cost

func unlock():
	unlock_progress.hide()
	map_button.show()
