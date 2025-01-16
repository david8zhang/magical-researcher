class_name StatIncreaseRow
extends HBoxContainer

@onready var stat_name = $StatName as Label
@onready var stat_value = $StatValue as Label
@onready var confirm_button = $Button as Button

# Called when the node enters the scene tree for the first time.
func _ready():
	confirm_button.pressed.connect(on_confirm_stat_increases)

func on_confirm_stat_increases():
	hide()