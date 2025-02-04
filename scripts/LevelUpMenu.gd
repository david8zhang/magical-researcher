class_name LevelUpMenu
extends Control

@onready var attack_row = $Panel/VBoxContainer/Attack as StatIncreaseRow
@onready var defense_row = $Panel/VBoxContainer/Defense as StatIncreaseRow
@onready var max_hp_row = $Panel/VBoxContainer/MaxHP as StatIncreaseRow
@onready var speed_row = $Panel/VBoxContainer/Speed as StatIncreaseRow
@onready var available_points_text = $Panel/StatPoints as RichTextLabel
@onready var confirm_button = $Panel/ConfirmButton as Button
@onready var game = get_node("/root/Main") as Game

var num_stat_points = 0

func _ready():
	confirm_button.pressed.connect(on_confirm_stat_increase)
	attack_row.level_up_menu = self
	defense_row.level_up_menu = self
	max_hp_row.level_up_menu = self
	speed_row.level_up_menu = self

func on_confirm_stat_increase():
	var player = game.player as Player
	player.attack = attack_row.get_value()
	player.defense = defense_row.get_value()
	player.max_hp = max_hp_row.get_value()
	player.speed = speed_row.get_value()
	hide()

func show_menu(player: Player):
	attack_row.set_stat_value(player.attack)
	defense_row.set_stat_value(player.defense)
	max_hp_row.set_stat_value(player.max_hp)
	speed_row.set_stat_value(player.speed)
	available_points_text.text = "[center][i]Available Points: " + str(num_stat_points) + "[i][center]"
	show()

func decrease_stat_points():
	num_stat_points -= 1
	available_points_text.text = "[center][i]Available Points: " + str(num_stat_points) + "[i][center]"