class_name DebugMenu
extends Control

@onready var game = get_node("/root/Main") as Game
@onready var damage_button = $VBoxContainer/DamageButton as Button
@onready var unlock_basic_spell_button = $VBoxContainer/UnlockBasicSpellButton as Button

func _ready():
	damage_button.pressed.connect(deal_damage_to_player)
	unlock_basic_spell_button.pressed.connect(unlock_basic_spell)

func deal_damage_to_player():
	game.player.take_damage(5)

func unlock_basic_spell():
	var spell_progress_menu = game.player.spell_progress_menu
	spell_progress_menu.force_unlock_spell("Basic Spell")