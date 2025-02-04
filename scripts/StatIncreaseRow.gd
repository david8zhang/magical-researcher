class_name StatIncreaseRow
extends HBoxContainer

@onready var stat_name = $StatName as Label
@onready var stat_value = $StatValue as Label
@onready var increase_button = $Button as Button
@export var stat_name_value = ""
var level_up_menu: LevelUpMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	increase_button.pressed.connect(on_increase_stat)
	stat_name.text = stat_name_value

func on_increase_stat():
	if level_up_menu.num_stat_points > 0:
		# level_up_menu.stat_increased -= 1
		level_up_menu.decrease_stat_points()
		var stat_value_int = stat_value.text.to_int()
		if stat_name_value == "Max HP" or stat_name_value == "Speed":
			stat_value_int += 10
		else:
			stat_value_int += 1
		stat_value.text = str(stat_value_int)

func set_stat_value(value: int):
	stat_value.text = str(value)

func get_value():
	return stat_value.text.to_int()
