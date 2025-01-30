class_name SpellUnlockAlert
extends Control

@onready var spell_name_label: Label = $Panel/SpellName
@onready var dismiss_button: Button = $Panel/Button


# Called when the node enters the scene tree for the first time.
func _ready():
	dismiss_button.pressed.connect(dismiss_label)
	position.x = 300

func set_spell_name(spell_name: String):
	spell_name_label.text = spell_name

func show_popup():
	var tween = create_tween()
	tween.tween_property(self, "position:x", 0, 0.5)

func dismiss_label():
	queue_free()
