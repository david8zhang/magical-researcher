class_name DebugMenu
extends Control

@onready var game = get_node("/root/Main") as Game
@onready var damage_button = $VBoxContainer/DamageButton as Button

func _ready():
	damage_button.pressed.connect(deal_damage_to_player)

func deal_damage_to_player():
	game.player.take_damage(5)