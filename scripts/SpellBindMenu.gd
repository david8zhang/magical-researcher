class_name SpellBindMenu
extends Control

@onready var spell_bind_option_1 = $Panel/SpellBindOption as SpellBindOption
@onready var spell_bind_option_2 = $Panel/SpellBindOption2 as SpellBindOption
@onready var confirm_button: Button = $Panel/Confirm
@onready var game = get_node("/root/Main") as Game

var spell_to_bind: DamageSpell

func _ready():
	init_spell_bind_option(spell_bind_option_1, SpellBindOption.MouseButtons.LMB)
	init_spell_bind_option(spell_bind_option_2, SpellBindOption.MouseButtons.RMB)
	confirm_button.pressed.connect(confirm_spell_binding)

func init_spell_bind_option(spell_bind_option: SpellBindOption, mouse_button: SpellBindOption.MouseButtons):
	var callable = Callable(self, "bind_spell_to_option").bind(spell_bind_option)
	spell_bind_option.pressed.connect(callable)
	spell_bind_option.spell_bind_menu = self
	spell_bind_option.button_to_bind = mouse_button

func confirm_spell_binding():
	var player = game.player as Player
	if spell_bind_option_1.spell_ref != null:
		player.active_spell = spell_bind_option_1.spell_ref
	player.spell_progress_menu.hide()
	hide()

func bind_spell_to_option(spell_bind_option: SpellBindOption):
	var other_spell_bind_option = spell_bind_option_2 if spell_bind_option == spell_bind_option_1 else spell_bind_option_1
	if other_spell_bind_option.spell_ref == spell_to_bind:
		other_spell_bind_option.unbind_spell()
	spell_bind_option.bind_spell(spell_to_bind)
