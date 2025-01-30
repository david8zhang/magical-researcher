class_name Game
extends Node2D

@onready var player = $Player as Player
@onready var canvas_layer = $CanvasLayer
@export var spell_unlock_alert_scene: PackedScene

enum Side {
	Player,
	Enemy
}

func _ready():
	var viewport_rect = get_viewport_rect()
	player.global_position = viewport_rect.get_center()
	player.on_death.connect(handle_game_over)

func handle_game_over():
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")

func create_new_spell_unlock_alert(spell_name: String):
	print("went here!")
	var spell_unlock_alert = spell_unlock_alert_scene.instantiate() as SpellUnlockAlert
	canvas_layer.add_child(spell_unlock_alert)
	spell_unlock_alert.set_spell_name(spell_name)
	spell_unlock_alert.show_popup()
