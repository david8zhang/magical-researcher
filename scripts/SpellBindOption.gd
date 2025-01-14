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

func _ready():
	pressed.connect(bind_spell)

func bind_spell():
	var spell_to_bind = spell_bind_menu.spell_to_bind
	if spell_bind_menu.spell_to_bind != null:
		spell_label.text = spell_to_bind.spell_name
		spell_icon.texture = load(spell_to_bind.spell_icon_path)
